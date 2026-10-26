import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_icon_button.dart';
import 'package:metro_mobile/design_system/models/chat_enums.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Hai nút 👍 / 👎 dưới câu trả lời của bot. Chạm lại để bỏ chọn.
class ChatFeedbackBar extends StatelessWidget {
  const ChatFeedbackBar({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ChatFeedback value;
  final ValueChanged<ChatFeedback> onChanged;

  void _toggle(ChatFeedback target) =>
      onChanged(value == target ? ChatFeedback.none : target);

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final primary = context.colors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MetroIconButton(
          icon: LucideIcons.thumbsUp,
          tooltip: context.l10n.feedbackHelpful,
          color: value == ChatFeedback.like ? primary : m.mutedForeground,
          onPressed: () => _toggle(ChatFeedback.like),
        ),
        MetroIconButton(
          icon: LucideIcons.thumbsDown,
          tooltip: context.l10n.feedbackNotHelpful,
          color: value == ChatFeedback.dislike
              ? m.destructive
              : m.mutedForeground,
          onPressed: () => _toggle(ChatFeedback.dislike),
        ),
      ],
    );
  }
}
