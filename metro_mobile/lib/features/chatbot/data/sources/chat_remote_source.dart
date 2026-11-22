import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';
import 'package:metro_mobile/features/chatbot/domain/repositories/chat_repository.dart';

typedef _Json = Map<String, Object?>;

/// `POST /api/v1/chatbot/messages`. Backend tạo phiên ở câu hỏi đầu tiên
/// (`sessionId` rỗng) nên app tự cấp mã phiên tạm, rồi nhớ `sessionId`
/// backend trả về cho các câu tiếp theo.
class ChatRemoteSource implements ChatRepository {
  ChatRemoteSource(this._dio);
  final Dio _dio;

  final _sessions = <String, int>{};
  var _seq = 0;

  static const _greeting =
      'Chào bạn! Mình có thể giúp tra giờ tàu, giá vé, lộ trình hoặc '
      'thông tin ga.';
  static const _suggestions = [
    'Giá vé từ Bến Thành đến Suối Tiên?',
    'Giờ tàu chạy hôm nay',
    'Cách mua vé tháng',
  ];

  Future<_Json> _post(String path, _Json body) async {
    try {
      return (await _dio.post<_Json>(path, data: body)).data ?? const {};
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<(String, ChatReply)> startSession() async => (
    'local-${++_seq}',
    const ChatReply(messageId: '', text: _greeting, suggestions: _suggestions),
  );

  @override
  Future<ChatReply> ask(String token, String question) async {
    final _Json j;
    try {
      j = await _post('/api/v1/chatbot/messages', {
        'sessionId': _sessions[token],
        'content': question,
      });
    } on NotFoundFailure {
      // Phiên backend không còn (đổi tài khoản, dữ liệu bị xoá): mở phiên mới
      // một lần thay vì để mọi câu hỏi sau đều lỗi 404.
      if (_sessions.remove(token) == null) rethrow;
      return await ask(token, question);
    }
    if (j['sessionId'] case final num id) _sessions[token] = id.toInt();
    final text = j['answer'] as String? ?? '';
    return ChatReply(
      messageId: '${j['messageId'] ?? ''}',
      text: text,
      suggestions: placeChoiceSuggestions(text),
    );
  }

  /// Backend hỏi lại địa danh bằng danh sách đánh số ("1. …", "2. …") và hiểu
  /// câu trả lời "Số 1", "Số 2"; đổi thành gợi ý trả lời nhanh.
  static List<String> placeChoiceSuggestions(String answer) {
    final numbers = RegExp(
      r'^\s*(\d+)\.\s+\S',
      multiLine: true,
    ).allMatches(answer).map((m) => m.group(1)!).toSet();
    if (numbers.length > 5) return const [];
    return [for (final n in numbers) 'Số $n'];
  }

  @override
  Future<void> sendFeedback(String messageId, MessageFeedback f) async {
    if (f == MessageFeedback.none || messageId.isEmpty) return;
    await _post('/api/v1/chatbot/messages/$messageId/feedback', {
      'feedback': f.name.toUpperCase(),
    });
  }
}
