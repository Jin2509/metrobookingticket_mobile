import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Phản hồi HTTP giả, đi qua transformer thật của Dio.
class FakeResponse {
  const FakeResponse(this.status, {this.json, this.headers = const {}});

  /// Body rỗng khi `null`, giống 202/204 và 401/403 của lớp bảo mật.
  final Map<String, dynamic>? json;
  final int status;
  final Map<String, String> headers;
}

typedef FakeHandler = FutureOr<FakeResponse> Function(RequestOptions req);

/// Adapter giả: ghi lại request, trả theo [handler].
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.handler);

  FakeHandler handler;
  final requests = <RequestOptions>[];

  Iterable<RequestOptions> to(String path) =>
      requests.where((r) => r.path == path);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final res = await handler(options);
    final json = res.json;
    return ResponseBody.fromString(
      json == null ? '' : jsonEncode(json),
      res.status,
      headers: {
        if (json != null)
          Headers.contentTypeHeader: [
            if (res.status >= 400)
              'application/problem+json'
            else
              Headers.jsonContentType,
          ],
        for (final e in res.headers.entries) e.key.toLowerCase(): [e.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
