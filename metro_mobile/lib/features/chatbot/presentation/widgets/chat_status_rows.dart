import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_attachment_view.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Futu đang trả lời…`.
class ChatTypingRow extends StatelessWidget {
  const ChatTypingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ExcludeSemantics(
          child: MetroMascot(
            size: ChatFutuRow.size,
            mood: MascotMood.happy,
            celebrate: true,
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
        const ExcludeSemantics(
          child: MetroMascot(size: ChatFutuRow.size, mood: MascotMood.worried),
        ),
        MetroSpacing.gapXs,
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

/// Đặt Futu cạnh tin nhắn của bot. Chỉ tin mới nhất hiện Futu, các tin trước
/// chừa chỗ để thẳng hàng.
class ChatFutuRow extends StatelessWidget {
  const ChatFutuRow({
    required this.show,
    required this.avatar,
    required this.child,
    super.key,
  });

  static const size = 36.0;

  final bool show;
  final bool avatar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!show) return child;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox.square(
          dimension: size,
          child: avatar
              ? const ExcludeSemantics(child: MetroMascot(size: size))
              : null,
        ),
        MetroSpacing.gapXs,
        Expanded(child: child),
      ],
    );
  }
}

/// Đầu phiên chat: Futu giới thiệu và mở nhanh các việc hay cần hướng dẫn.
class ChatFutuGuide extends StatelessWidget {
  const ChatFutuGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget action(String label, IconData icon, String to) => MetroButton(
      label: label,
      icon: icon,
      size: MetroButtonSize.sm,
      variant: MetroButtonVariant.secondary,
      onPressed: () => openFromChat(context, to),
    );
    return Column(
      children: [
        const ExcludeSemantics(
          child: MetroMascot(size: 96, mood: MascotMood.happy, celebrate: true),
        ),
        MetroSpacing.gapXs,
        Text(
          l.chatFutuTitle,
          textAlign: TextAlign.center,
          style: context.text.titleSmall,
        ),
        MetroSpacing.gapSm,
        Wrap(
          alignment: WrapAlignment.center,
          spacing: MetroSpacing.xs,
          runSpacing: MetroSpacing.xs,
          children: [
            action(l.buyTicket, LucideIcons.ticketPlus, Routes.buy()),
            action(l.routeShort, LucideIcons.route, Routes.routeSearch()),
            action(
              l.studentVerifyTitle,
              LucideIcons.graduationCap,
              Routes.pStudentVerify,
            ),
          ],
        ),
      ],
    );
  }
}
