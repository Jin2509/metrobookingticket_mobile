import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/chatbot/chatbot_providers.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';

@immutable
class ChatState {
  const ChatState({
    this.messages = const [],
    this.sessionToken,
    this.sending = false,
    this.failedQuestion,
  });

  final List<ChatMessage> messages;
  final String? sessionToken;
  final bool sending;

  /// A4: câu hỏi gửi lỗi, chờ "Thử lại".
  final String? failedQuestion;

  List<String> get suggestions {
    final bot = messages.lastWhere(
      (m) => m.role == ChatRole.bot,
      orElse: () => const ChatMessage(id: '', role: ChatRole.bot, text: ''),
    );
    return bot.suggestions;
  }

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? sessionToken,
    bool sending = false,
    String? failedQuestion,
  }) => ChatState(
    messages: messages ?? this.messages,
    sessionToken: sessionToken ?? this.sessionToken,
    sending: sending,
    failedQuestion: failedQuestion,
  );
}

/// Giữ hội thoại khi đổi tab; đổi người dùng thì mở phiên mới.
final chatControllerProvider = NotifierProvider<ChatController, ChatState>(
  ChatController.new,
);

class ChatController extends Notifier<ChatState> {
  int _seq = 0;

  @override
  ChatState build() {
    final user = ref.watch(authControllerProvider.select((s) => s.value?.id));
    if (user != null) unawaited(Future.microtask(_start));
    return const ChatState(sending: true);
  }

  Future<void> _start() async {
    try {
      final (token, greeting) = await ref.read(chatWithBotProvider).start();
      state = ChatState(
        sessionToken: token,
        messages: [ChatMessage.fromReply(greeting)],
      );
    } on Failure {
      state = const ChatState(failedQuestion: '');
    }
  }

  Future<void> newSession() async {
    state = const ChatState(sending: true);
    await _start();
  }

  Future<void> send(String text) async {
    final q = text.trim();
    if (q.isEmpty || state.sending) return;
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(id: 'U${_seq++}', role: ChatRole.user, text: q),
      ],
    );
    await _ask(q);
  }

  /// A4: gửi lại câu hỏi lỗi.
  Future<void> retry() async {
    final q = state.failedQuestion;
    if (q == null) return;
    if (q.isEmpty) {
      await newSession();
      return;
    }
    await _ask(q);
  }

  Future<void> _ask(String q) async {
    final token = state.sessionToken;
    if (token == null) return;
    state = state.copyWith(sending: true);
    try {
      final reply = await ref.read(chatWithBotProvider).ask(token, q);
      state = state.copyWith(
        messages: [...state.messages, ChatMessage.fromReply(reply)],
      );
    } on Failure {
      state = state.copyWith(failedQuestion: q);
    }
  }

  Future<void> feedback(String messageId, MessageFeedback f) async {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          if (m.id == messageId) m.withFeedback(f) else m,
      ],
      failedQuestion: state.failedQuestion,
    );
    await ref.read(chatWithBotProvider).feedback(messageId, f);
  }
}
