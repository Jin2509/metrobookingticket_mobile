import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';
import 'package:metro_mobile/features/chatbot/domain/repositories/chat_repository.dart';

typedef _Json = Map<String, Object?>;

/// `POST /api/chat` (mục 9, "chưa hỗ trợ, cần làm rõ"). Phiên và
/// feedback là endpoint giả định.
class ChatRemoteSource implements ChatRepository {
  const ChatRemoteSource(this._dio);
  final Dio _dio;

  Future<_Json> _post(String path, _Json body) async {
    try {
      return (await _dio.post<_Json>(path, data: body)).data ?? const {};
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  ChatAttachment? _attachment(_Json j) => switch (j['type']) {
    'TICKET' => TicketAttachment(
      ticketId: '${j['ticketId']}',
      title: j['title']! as String,
      validUntil: DateTime.parse(j['validUntil']! as String),
    ),
    'STATION' => StationAttachment(
      stationId: '${j['stationId']}',
      name: j['name']! as String,
    ),
    'ROUTE' => RouteAttachment(fromId: '${j['fromId']}', toId: '${j['toId']}'),
    _ => null,
  };

  ChatReply _reply(_Json j) => ChatReply(
    messageId: '${j['messageId']}',
    text: j['answer'] as String? ?? '',
    attachments: [
      for (final a in j['attachments'] as List? ?? const [])
        ?_attachment(a as _Json),
    ],
    suggestions: [for (final s in j['suggestions'] as List? ?? const []) '$s'],
  );

  @override
  Future<(String, ChatReply)> startSession() async {
    final j = await _post('/api/chat/session', const {});
    return (j['sessionToken']! as String, _reply(j));
  }

  @override
  Future<ChatReply> ask(String token, String question) async => _reply(
    await _post('/api/chat', {'sessionToken': token, 'question': question}),
  );

  @override
  Future<void> sendFeedback(String messageId, MessageFeedback f) => _post(
    '/api/chat/$messageId/feedback',
    {'feedback': f.name.toUpperCase()},
  );
}
