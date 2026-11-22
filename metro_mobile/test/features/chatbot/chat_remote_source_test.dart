import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/dio_client.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';
import 'package:metro_mobile/features/chatbot/data/sources/chat_remote_source.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';

import '../../helpers/fake_http.dart';

Map<String, dynamic> _body(dynamic data) => data is String
    ? jsonDecode(data) as Map<String, dynamic>
    : Map<String, dynamic>.from(data as Map);

void main() {
  late FakeHttpAdapter http;
  late ChatRemoteSource source;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    http = FakeHttpAdapter((_) => const FakeResponse(204));
    source = ChatRemoteSource(
      createDio(
        store: SecureStore(),
        onSessionExpired: () async {},
        onTokensRefreshed: () async {},
        baseUrl: 'http://test',
        adapter: http,
      ),
    );
  });

  test(
    'câu đầu gửi sessionId rỗng, câu sau dùng sessionId backend trả về',
    () async {
      http.handler = (_) => const FakeResponse(
        200,
        json: {
          'sessionId': 41,
          'messageId': 7,
          'answer': 'Giá vé lượt từ 7.000đ.',
          'actionCalled': null,
        },
      );
      final (token, greeting) = await source.startSession();
      expect(greeting.text, isNotEmpty);

      final first = await source.ask(token, 'Giá vé?');
      await source.ask(token, 'Còn vé tháng?');

      expect(first.messageId, '7');
      expect(first.text, 'Giá vé lượt từ 7.000đ.');
      expect(first.suggestions, isEmpty);
      final bodies = http
          .to('/api/v1/chatbot/messages')
          .map((r) => _body(r.data))
          .toList();
      expect(bodies[0], {'sessionId': null, 'content': 'Giá vé?'});
      expect(bodies[1], {'sessionId': 41, 'content': 'Còn vé tháng?'});
    },
  );

  test('phiên backend mất (404) thì mở phiên mới một lần', () async {
    var calls = 0;
    http.handler = (req) {
      calls++;
      if (calls == 1) {
        return const FakeResponse(
          200,
          json: {'sessionId': 5, 'messageId': 1, 'answer': 'a'},
        );
      }
      if (_body(req.data)['sessionId'] == 5) {
        return const FakeResponse(
          404,
          json: {'status': 404, 'detail': 'Không tìm thấy phiên hội thoại'},
        );
      }
      return const FakeResponse(
        200,
        json: {'sessionId': 9, 'messageId': 2, 'answer': 'b'},
      );
    };
    final (token, _) = await source.startSession();
    await source.ask(token, 'q1');

    final reply = await source.ask(token, 'q2');

    expect(reply.text, 'b');
    final ids = http.requests.map((r) => _body(r.data)['sessionId']).toList();
    expect(ids, [null, 5, null]);
  });

  test('404 khi chưa có phiên thì báo lỗi, không lặp vô hạn', () async {
    http.handler = (_) =>
        const FakeResponse(404, json: {'status': 404, 'detail': 'x'});
    final (token, _) = await source.startSession();

    await expectLater(source.ask(token, 'q'), throwsA(isA<NotFoundFailure>()));
    expect(http.requests, hasLength(1));
  });

  test('429 giữ thông điệp backend', () async {
    http.handler = (_) => const FakeResponse(
      429,
      json: {
        'status': 429,
        'detail': 'Bạn hỏi quá nhanh, vui lòng thử lại sau ít phút',
      },
    );
    final (token, _) = await source.startSession();

    await expectLater(
      source.ask(token, 'q'),
      throwsA(
        isA<RateLimitedFailure>().having(
          (f) => f.message,
          'message',
          contains('quá nhanh'),
        ),
      ),
    );
  });

  test('danh sách địa danh đánh số thành gợi ý "Số n"', () async {
    http.handler = (_) => const FakeResponse(
      200,
      json: {
        'sessionId': 3,
        'messageId': 4,
        'answer':
            'Mình tìm thấy một số địa danh phù hợp. '
            'Bạn muốn nói đến địa điểm nào?\n'
            '1. Chợ Bến Thành, Quận 1 — ga gần nhất: Bến Thành (120 m)\n'
            '2. Chợ Lớn, Quận 5',
      },
    );
    final (token, _) = await source.startSession();

    final reply = await source.ask(token, 'ga gần chợ');

    expect(reply.suggestions, ['Số 1', 'Số 2']);
  });

  test('gợi ý không bắt nhầm số trong câu thường', () {
    expect(
      ChatRemoteSource.placeChoiceSuggestions(
        'Giá vé 7.000đ, tàu cách 8 phút.',
      ),
      isEmpty,
    );
  });

  test('feedback gửi LIKE/DISLIKE đúng path', () async {
    await source.sendFeedback('12', MessageFeedback.dislike);
    await source.sendFeedback('', MessageFeedback.like);

    expect(http.requests.single.path, '/api/v1/chatbot/messages/12/feedback');
    expect(_body(http.requests.single.data), {'feedback': 'DISLIKE'});
  });
}
