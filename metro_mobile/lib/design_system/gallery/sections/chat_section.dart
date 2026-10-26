import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/models/chat_enums.dart';
import 'package:metro_mobile/design_system/molecules/chat_bubble.dart';
import 'package:metro_mobile/design_system/molecules/chat_quick_replies.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  ChatFeedback _feedback = ChatFeedback.none;

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'ChatBubble · Quick replies',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ChatBubble(
            sender: ChatSender.bot,
            text: 'Chào bạn! Mình có thể giúp tra giá vé, ga, xe buýt…',
          ),
          MetroSpacing.gapSm,
          const ChatBubble(
            sender: ChatSender.user,
            text: 'Vé của tôi còn hạn?',
          ),
          MetroSpacing.gapSm,
          ChatBubble(
            sender: ChatSender.bot,
            text: 'Vé tháng HSSV hết hạn 23/11/2026.',
            attachment: MetroButton(
              label: 'Xem vé',
              size: MetroButtonSize.sm,
              variant: MetroButtonVariant.secondary,
              onPressed: () {},
            ),
            feedback: _feedback,
            onFeedback: (f) => setState(() => _feedback = f),
          ),
          MetroSpacing.gapXs,
          ChatQuickReplies(
            suggestions: const [
              'Giá vé BT – Suối Tiên?',
              'Xe buýt quanh ga Thủ Đức',
              'Điểm của tôi',
            ],
            onSelected: (_) {},
          ),
        ],
      ),
    );
  }
}
