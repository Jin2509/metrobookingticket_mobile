import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/models/chat_enums.dart';
import 'package:metro_mobile/design_system/molecules/chat_feedback_bar.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Bong bóng chat (P70). Bot có thể kèm rich card và nút Like/Dislike.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.text,
    required this.sender,
    this.attachment,
    this.feedback = ChatFeedback.none,
    this.onFeedback,
    super.key,
  });

  final String text;
  final ChatSender sender;

  /// Rich card (vé, ga, tuyến buýt) hiển thị dưới nội dung (UC14-03).
  final Widget? attachment;
  final ChatFeedback feedback;
  final ValueChanged<ChatFeedback>? onFeedback;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final isUser = sender == ChatSender.user;
    const r = Radius.circular(MetroRadius.xl);
    const tail = Radius.circular(MetroRadius.sm / 2);
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .78,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: MetroSpacing.md,
                vertical: MetroSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isUser ? context.colors.primary : m.card,
                border: isUser ? null : Border.all(color: m.border),
                borderRadius: BorderRadius.only(
                  topLeft: r,
                  topRight: r,
                  bottomLeft: isUser ? r : tail,
                  bottomRight: isUser ? tail : r,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: context.text.bodyMedium?.copyWith(
                      color: isUser ? context.colors.onPrimary : null,
                    ),
                  ),
                  if (attachment != null) ...[MetroSpacing.gapSm, attachment!],
                ],
              ),
            ),
            if (!isUser && onFeedback != null)
              ChatFeedbackBar(value: feedback, onChanged: onFeedback!),
          ],
        ),
      ),
    );
  }
}
