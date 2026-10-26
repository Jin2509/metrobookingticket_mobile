import 'package:flutter/foundation.dart';

enum ChatRole { user, bot }

/// `chatbot_message.feedback`.
enum MessageFeedback { none, like, dislike }

/// Rich card kèm câu trả lời (UC14-03). Không bao giờ chứa QR hay
/// thông tin thanh toán.
sealed class ChatAttachment {
  const ChatAttachment();
}

class TicketAttachment extends ChatAttachment {
  const TicketAttachment({
    required this.ticketId,
    required this.title,
    required this.validUntil,
  });
  final String ticketId;
  final String title;
  final DateTime validUntil;
}

class StationAttachment extends ChatAttachment {
  const StationAttachment({required this.stationId, required this.name});
  final String stationId;
  final String name;
}

class RouteAttachment extends ChatAttachment {
  const RouteAttachment({required this.fromId, required this.toId});
  final String fromId;
  final String toId;
}

class BusAttachment extends ChatAttachment {
  const BusAttachment({required this.stops});

  /// (tên trạm, số hiệu tuyến buýt).
  final List<(String, List<String>)> stops;
}

/// Một câu trả lời của bot.
@immutable
class ChatReply {
  const ChatReply({
    required this.messageId,
    required this.text,
    this.attachments = const [],
    this.suggestions = const [],
  });

  final String messageId;
  final String text;
  final List<ChatAttachment> attachments;

  /// Gợi ý trả lời nhanh.
  final List<String> suggestions;
}

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.attachments = const [],
    this.suggestions = const [],
    this.feedback = MessageFeedback.none,
  });

  factory ChatMessage.fromReply(ChatReply r) => ChatMessage(
    id: r.messageId,
    role: ChatRole.bot,
    text: r.text,
    attachments: r.attachments,
    suggestions: r.suggestions,
  );

  final String id;
  final ChatRole role;
  final String text;
  final List<ChatAttachment> attachments;
  final List<String> suggestions;
  final MessageFeedback feedback;

  ChatMessage withFeedback(MessageFeedback f) => ChatMessage(
    id: id,
    role: role,
    text: text,
    attachments: attachments,
    suggestions: suggestions,
    feedback: f,
  );
}
