import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';
import 'package:metro_mobile/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_attachment_view.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_status_rows.dart';

/// Hội thoại; tự cuộn xuống tin mới nhất.
class ChatMessageList extends ConsumerStatefulWidget {
  const ChatMessageList({super.key});

  @override
  ConsumerState<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends ConsumerState<ChatMessageList> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _toBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
  });

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(chatControllerProvider);
    final ctrl = ref.read(chatControllerProvider.notifier);
    ref.listen(chatControllerProvider, (_, _) => _toBottom());
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        for (final m in s.messages) ...[
          ChatBubble(
            text: m.text,
            sender: m.role == ChatRole.user ? ChatSender.user : ChatSender.bot,
            feedback: ChatFeedback.values[m.feedback.index],
            // Lời chào đầu phiên không cần đánh giá.
            onFeedback: m.role == ChatRole.bot && m != s.messages.first
                ? (f) => ctrl.feedback(m.id, MessageFeedback.values[f.index])
                : null,
            attachment: m.attachments.isEmpty
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final a in m.attachments)
                        ChatAttachmentView(attachment: a),
                    ],
                  ),
          ),
          MetroSpacing.gapSm,
        ],
        if (s.sending) const ChatTypingRow(),
        if (s.failedQuestion != null) ChatErrorRow(onRetry: ctrl.retry),
      ],
    );
  }
}
