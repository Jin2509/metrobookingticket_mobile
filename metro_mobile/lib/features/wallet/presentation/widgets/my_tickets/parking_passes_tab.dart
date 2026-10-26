import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/wallet_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Tab "Gửi xe": các lượt gửi xe đang hiệu lực (P42).
class ParkingPassesTab extends ConsumerWidget {
  const ParkingPassesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView(
      value: ref.watch(activeParkingProvider),
      onRetry: () => ref.invalidate(activeParkingProvider),
      data: (list) => list.isEmpty
          ? EmptyState(
              icon: LucideIcons.squareParking,
              title: context.l10n.noParkingPasses,
              actionLabel: context.l10n.registerParking,
              onAction: () => context.push(Routes.pParkingBook),
            )
          : ListView(
              padding: const EdgeInsets.all(MetroSpacing.md),
              children: [
                MetroButton(
                  label: context.l10n.registerParking,
                  icon: LucideIcons.plus,
                  variant: MetroButtonVariant.outline,
                  expand: true,
                  onPressed: () => context.push(Routes.pParkingBook),
                ),
                MetroSpacing.gapSm,
                for (final p in list) ...[
                  ParkingPassCard(
                    lotName: p.lotName,
                    plate: p.plate,
                    vehicle: vehicleKindOf(p.vehicleCode),
                    status: p.status,
                    since: p.since,
                    onOpenQr: () => context.push(Routes.parkingPass(p.id)),
                  ),
                  MetroSpacing.gapSm,
                ],
              ],
            ),
    );
  }
}
