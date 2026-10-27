import 'package:flutter/material.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_panel.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P70. Trợ lý ảo (UC14) dạng trang, cho deep link `/p/assistant`.
/// Trong app, Trợ lý mở từ nút nổi bằng `ChatSheet`.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.assistantTitle),
        actions: const [NewSessionButton()],
      ),
      body: const ChatPanel(),
    );
  }
}
