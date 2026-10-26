import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';

abstract interface class ChatRepository {
  /// Tạo phiên mới (`session_token`) kèm lời chào.
  Future<(String, ChatReply)> startSession();

  /// `POST /api/chat {sessionToken, question}`.
  Future<ChatReply> ask(String sessionToken, String question);

  Future<void> sendFeedback(String messageId, MessageFeedback feedback);
}
