import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `◌ Trợ lý đang trả lời…`.
class ChatTypingRow extends StatelessWidget {
  const ChatTypingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colors.primary,
          ),
        ),
        MetroSpacing.gapXs,
        Text(context.l10n.assistantTyping, style: context.text.bodySmall),
      ],
    );
  }
}

/// A4: `Không gửi được câu hỏi · Thử lại`.
class ChatErrorRow extends StatelessWidget {
  const ChatErrorRow({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.sendFailed,
            style: context.text.bodySmall?.copyWith(
              color: context.metro.destructive,
            ),
          ),
        ),
        TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
      ],
    );
  }
}
