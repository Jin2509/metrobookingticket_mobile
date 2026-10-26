import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_input_bar.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_message_list.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P70. Trợ lý ảo (UC14).
class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(chatControllerProvider);
    final ctrl = ref.read(chatControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.assistantTitle),
        actions: [
          TextButton(
            onPressed: ctrl.newSession,
            child: Text(context.l10n.newSession),
          ),
        ],
      ),
      body: Column(
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
      ),
    );
  }
}
