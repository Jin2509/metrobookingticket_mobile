import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';
import 'package:metro_mobile/features/chatbot/domain/repositories/chat_repository.dart';

/// UC14-01/02/03: hỏi trợ lý ảo.
class ChatWithBot {
  const ChatWithBot(this._repo);
  final ChatRepository _repo;

  static const maxLength = 300;

  Future<(String, ChatReply)> start() => _repo.startSession();

  Future<ChatReply> ask(String token, String question) {
    final q = question.trim();
    if (q.isEmpty) throw const ValidationFailure('Vui lòng nhập câu hỏi');
    if (q.length > maxLength) {
      throw const ValidationFailure('Câu hỏi tối đa 300 ký tự');
    }
    return _repo.ask(token, q);
  }

  Future<void> feedback(String messageId, MessageFeedback f) =>
      _repo.sendFeedback(messageId, f);
}
