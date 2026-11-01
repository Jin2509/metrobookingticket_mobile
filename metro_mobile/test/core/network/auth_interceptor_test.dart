import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/network/dio_client.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';

import '../../helpers/fake_http.dart';

const _refreshPath = '/api/auth/refresh';

void main() {
  late SecureStore store;
  late FakeHttpAdapter http;
  late Dio dio;
  late int expired;
  late int refreshed;

  /// Backend: token `new-a` hợp lệ, refresh trả cặp `new-a` / `new-r`.
  FakeResponse backend(RequestOptions req) {
    if (req.path == _refreshPath) {
      return const FakeResponse(
        200,
        json: {
          'accessToken': 'new-a',
          'tokenType': 'Bearer',
          'refreshToken': 'new-r',
        },
      );
    }
    return req.headers['Authorization'] == 'Bearer new-a'
        ? const FakeResponse(200, json: {'ok': true})
        : const FakeResponse(401);
  }

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    store = SecureStore();
    await store.saveTokens(access: 'old-a', refresh: 'old-r');
    expired = 0;
    refreshed = 0;
    http = FakeHttpAdapter(backend);
    dio = createDio(
      store: store,
      onSessionExpired: () async => expired++,
      onTokensRefreshed: () async => refreshed++,
      baseUrl: 'http://test',
      adapter: http,
    );
  });

  test('401: refresh, lưu cả 2 token mới, phát lại request', () async {
    final res = await dio.get<dynamic>('/api/me');
    expect(res.statusCode, 200);
    expect(await store.accessToken, 'new-a');
    expect(await store.refreshToken, 'new-r');
    expect(await SecureStore().refreshToken, 'new-r');
    expect(http.to('/api/me').last.headers['Authorization'], 'Bearer new-a');
    expect(refreshed, 1);
  });

  test('nhiều 401 cùng lúc chỉ gửi đúng 1 request refresh', () async {
    final gate = Completer<void>();
    http.handler = (req) async {
      if (req.path == _refreshPath) await gate.future;
      return backend(req);
    };
    final calls = [for (var i = 0; i < 5; i++) dio.get<dynamic>('/api/me')];
    await Future<void>.delayed(const Duration(milliseconds: 50));
    gate.complete();
    final results = await Future.wait(calls);

    expect(results.map((r) => r.statusCode), everyElement(200));
    expect(http.to(_refreshPath), hasLength(1));
    expect(http.to(_refreshPath).single.data, {'refreshToken': 'old-r'});
  });

  test('phát lại vẫn 401: dừng, không refresh lần 2', () async {
    http.handler = (req) =>
        req.path == _refreshPath ? backend(req) : const FakeResponse(401);
    await expectLater(
      dio.get<dynamic>('/api/me'),
      throwsA(isA<DioException>()),
    );
    expect(http.to(_refreshPath), hasLength(1));
    expect(http.to('/api/me'), hasLength(2));
  });

  for (final status in [401, 403]) {
    test('refresh $status: xóa token, báo phiên hết hạn', () async {
      http.handler = (req) => req.path == _refreshPath
          ? FakeResponse(status)
          : const FakeResponse(401);
      await expectLater(
        dio.get<dynamic>('/api/me'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            401,
          ),
        ),
      );
      expect(await store.refreshToken, isNull);
      expect(await store.accessToken, isNull);
      expect(expired, 1);
    });
  }

  test('refresh 5xx: giữ token, chưa đăng xuất, trả lỗi 5xx', () async {
    http.handler = (req) => req.path == _refreshPath
        ? const FakeResponse(503)
        : const FakeResponse(401);
    await expectLater(
      dio.get<dynamic>('/api/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          503,
        ),
      ),
    );
    expect(await store.refreshToken, 'old-r');
    expect(expired, 0);
  });

  test('refresh mất mạng: giữ token, chưa đăng xuất', () async {
    http.handler = (req) {
      if (req.path == _refreshPath) {
        throw DioException.connectionError(
          requestOptions: req,
          reason: 'offline',
        );
      }
      return const FakeResponse(401);
    };
    await expectLater(
      dio.get<dynamic>('/api/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
      ),
    );
    expect(await store.refreshToken, 'old-r');
    expect(expired, 0);
  });

  test('403 ở API thường không gọi refresh', () async {
    http.handler = (_) => const FakeResponse(403);
    await expectLater(
      dio.get<dynamic>('/api/me'),
      throwsA(isA<DioException>()),
    );
    expect(http.to(_refreshPath), isEmpty);
    expect(await store.refreshToken, 'old-r');
  });

  test('401 của API auth (sai mật khẩu) không gọi refresh', () async {
    http.handler = (_) => const FakeResponse(401);
    await expectLater(
      dio.post<dynamic>('/api/auth/login', data: {'email': 'a'}),
      throwsA(isA<DioException>()),
    );
    expect(http.to(_refreshPath), isEmpty);
    expect(expired, 0);
  });

  test('API auth không gửi token, riêng logout gửi kèm', () async {
    http.handler = (_) => const FakeResponse(204);
    await dio.post<dynamic>('/api/auth/login', data: <String, dynamic>{});
    await dio.post<dynamic>('/api/auth/logout', data: <String, dynamic>{});
    expect(http.to('/api/auth/login').single.headers['Authorization'], isNull);
    expect(
      http.to('/api/auth/logout').single.headers['Authorization'],
      'Bearer old-a',
    );
  });

  test('đăng xuất trong lúc refresh: không khôi phục token', () async {
    final gate = Completer<void>();
    http.handler = (req) async {
      if (req.path == _refreshPath) await gate.future;
      return backend(req);
    };
    final call = dio.get<dynamic>('/api/me');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await store.clear();
    gate.complete();
    await expectLater(call, throwsA(isA<DioException>()));
    expect(await store.refreshToken, isNull);
  });

  test('phiên không "Ghi nhớ" sau refresh vẫn không ghi xuống máy', () async {
    await store.saveTokens(access: 'old-a', refresh: 'old-r', persist: false);
    await dio.get<dynamic>('/api/me');
    expect(await store.refreshToken, 'new-r');
    expect(await SecureStore().refreshToken, isNull);
  });
}
