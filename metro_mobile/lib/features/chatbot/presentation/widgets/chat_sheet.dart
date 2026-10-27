import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_panel.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Trợ lý dạng sheet ~90% màn hình, mở từ nút nổi. Hội thoại giữ nguyên
/// khi đóng/mở lại (controller không autoDispose).
abstract final class ChatSheet {
  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      final mq = MediaQuery.of(ctx);
      final inset = mq.viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: inset),
        child: SizedBox(
          height: (mq.size.height - inset) * .86,
          child: const _ChatSheetBody(),
        ),
      );
    },
  );
}

class _ChatSheetBody extends StatelessWidget {
  const _ChatSheetBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MetroSpacing.xs),
          child: Row(
            children: [
              MetroSpacing.gapXs,
              Icon(LucideIcons.botMessageSquare, color: context.colors.primary),
              MetroSpacing.gapXs,
              Expanded(
                child: Text(
                  context.l10n.assistantTitle,
                  style: context.text.titleMedium,
                ),
              ),
              const NewSessionButton(),
              IconButton(
                tooltip: context.l10n.close,
                icon: const Icon(LucideIcons.x),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        const Expanded(child: ChatPanel()),
      ],
    );
  }
}
