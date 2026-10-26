import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/geo.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/nearby_controller.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/nearby_permission_prompt.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nội dung sheet theo trạng thái: gợi ý, đang tìm, bị từ chối, kết quả.
class NearbySheetContent extends ConsumerWidget {
  const NearbySheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nearbyControllerProvider);
    final ctrl = ref.read(nearbyControllerProvider.notifier);
    final catalog = ref.watch(catalogProvider).value;
    return switch (state.status) {
      NearbyStatus.idle => Padding(
        padding: MetroSpacing.screenPadding,
        child: MetroButton(
          label: context.l10n.findNearMe,
          icon: LucideIcons.locateFixed,
          variant: MetroButtonVariant.secondary,
          expand: true,
          onPressed: ctrl.locate,
        ),
      ),
      NearbyStatus.locating => const Padding(
        padding: MetroSpacing.screenPadding,
        child: Column(
          children: [
            MetroSkeleton(height: 48),
            MetroSpacing.gapXs,
            MetroSkeleton(height: 48),
          ],
        ),
      ),
      NearbyStatus.denied ||
      NearbyStatus.deniedForever ||
      NearbyStatus.serviceOff ||
      NearbyStatus.picking => NearbyPermissionPrompt(status: state.status),
      NearbyStatus.ready when state.error != null => ErrorState(
        message: state.error!,
        onRetry: ctrl.locate,
      ),
      NearbyStatus.ready => Column(
        children: [
          if (state.pickedOnMap)
            Text(context.l10n.byPickedLocation, style: context.text.labelSmall),
          for (final n in state.stations)
            if (catalog != null)
              StationTile(
                station: catalog.option(n.station),
                trailing: formatDistance(n.distanceM),
                onTap: () => context.push(Routes.stationDetail(n.station.id)),
              ),
        ],
      ),
    };
  }
}
