import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/nearby_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[◎]` Tìm ga gần nhất (UC5-02).
class LocateButton extends ConsumerWidget {
  const LocateButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = context.metro;
    return Material(
      color: m.card,
      shape: CircleBorder(side: BorderSide(color: m.border)),
      child: IconButton(
        tooltip: context.l10n.findNearby,
        iconSize: 22,
        padding: const EdgeInsets.all(MetroSpacing.sm),
        icon: Icon(LucideIcons.locateFixed, color: context.colors.primary),
        onPressed: () => ref.read(nearbyControllerProvider.notifier).locate(),
      ),
    );
  }
}
