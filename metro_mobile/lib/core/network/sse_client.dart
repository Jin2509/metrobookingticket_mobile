import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/backoff.dart';

/// Một sự kiện Server-Sent Events: `event:` + `data:` (đã nối nhiều dòng).
typedef SseEvent = ({String event, String data});

/// Nghe `text/event-stream` qua [dio] (có sẵn token của `AuthInterceptor`).
/// Mất kết nối thì thử lại theo [backoff] cho tới khi hủy lắng nghe.
Stream<SseEvent> sseEvents(Dio dio, String path, {Backoff? backoff}) {
  final wait = backoff ?? Backoff();
  late final StreamController<SseEvent> ctrl;
  CancelToken? cancel;
  var closed = false;

  Future<void> run() async {
    while (!closed) {
      cancel = CancelToken();
      try {
        final res = await dio.get<ResponseBody>(
          path,
          cancelToken: cancel,
          options: Options(
            responseType: ResponseType.stream,
            receiveTimeout: Duration.zero,
            headers: {'Accept': 'text/event-stream'},
          ),
        );
        wait.reset();
        var event = 'message';
        final data = StringBuffer();
        final lines = res.data!.stream
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter());
        await for (final line in lines) {
          if (line.isEmpty) {
            if (data.isNotEmpty) ctrl.add((event: event, data: '$data'));
            event = 'message';
            data.clear();
          } else if (line.startsWith('event:')) {
            event = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            if (data.isNotEmpty) data.write('\n');
            data.write(line.substring(5).trimLeft());
          }
        }
      } on Object {
        // Lỗi mạng / 401: thử lại sau.
      }
      if (closed) break;
      await Future<void>.delayed(wait.next());
    }
  }

  ctrl = StreamController<SseEvent>(
    onListen: () => unawaited(run()),
    onCancel: () {
      closed = true;
      cancel?.cancel();
    },
  );
  return ctrl.stream;
}
