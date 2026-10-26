import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/nearby_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// UC5-02 A1: không có vị trí → "Bật vị trí" hoặc "Chọn trên bản đồ".
class NearbyPermissionPrompt extends ConsumerWidget {
  const NearbyPermissionPrompt({required this.status, super.key});

  final NearbyStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(nearbyControllerProvider.notifier);
    if (status == NearbyStatus.picking) {
      return Padding(
        padding: MetroSpacing.screenPadding,
        child: Row(
          children: [
            Icon(LucideIcons.mapPinned, color: context.colors.primary),
            MetroSpacing.gapXs,
            Expanded(
              child: Text(
                context.l10n.tapMapToPick,
                style: context.text.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }
    final message = switch (status) {
      NearbyStatus.serviceOff => context.l10n.locationServiceOff,
      NearbyStatus.deniedForever => context.l10n.locationDeniedForever,
      _ => context.l10n.locationRationale,
    };
    return Padding(
      padding: MetroSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, style: context.text.bodySmall),
          MetroSpacing.gapSm,
          Row(
            children: [
              Expanded(
                child: MetroButton(
                  label: context.l10n.enableLocation,
                  size: MetroButtonSize.sm,
                  onPressed: status == NearbyStatus.denied
                      ? ctrl.locate
                      : ctrl.openSettings,
                ),
              ),
              MetroSpacing.gapXs,
              Expanded(
                child: MetroButton(
                  label: context.l10n.pickOnMap,
                  size: MetroButtonSize.sm,
                  variant: MetroButtonVariant.outline,
                  onPressed: ctrl.startPicking,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
