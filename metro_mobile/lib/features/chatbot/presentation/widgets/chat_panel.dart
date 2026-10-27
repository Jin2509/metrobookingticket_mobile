import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_input_bar.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_message_list.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Tin nhắn + gợi ý + ô nhập. Dùng trong sheet Trợ lý và trang P70.
class ChatPanel extends ConsumerWidget {
  const ChatPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(chatControllerProvider);
    final ctrl = ref.read(chatControllerProvider.notifier);
    return Column(
      children: [
        const Expanded(child: ChatMessageList()),
        if (s.suggestions.isNotEmpty && !s.sending)
          Padding(
            padding: const EdgeInsets.only(bottom: MetroSpacing.xs),
            child: ChatQuickReplies(
              suggestions: s.suggestions,
              onSelected: ctrl.send,
            ),
          ),
        ChatInputBar(onSend: ctrl.send, enabled: !s.sending),
      ],
    );
  }
}

/// Nút "Phiên mới" trên thanh tiêu đề.
class NewSessionButton extends ConsumerWidget {
  const NewSessionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    onPressed: ref.read(chatControllerProvider.notifier).newSession,
    child: Text(context.l10n.newSession),
  );
}
