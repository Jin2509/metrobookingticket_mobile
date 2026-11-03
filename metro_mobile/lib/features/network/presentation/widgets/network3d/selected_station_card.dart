import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/station_arrivals_provider.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/arrivals_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ nổi của ga đang chọn trên sơ đồ 3D. Chưa chọn ga thì hiện gợi ý.
class SelectedStationCard extends ConsumerWidget {
  const SelectedStationCard({
    required this.catalog,
    required this.stationId,
    required this.onClose,
    super.key,
  });

  final NetworkCatalog catalog;
  final String? stationId;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final station = stationId == null ? null : catalog.station(stationId!);
    if (station == null) {
      return MascotTip(text: context.l10n.network3dHint);
    }
    final arrivals = ref.watch(stationArrivalsProvider(station.id)).value;
    final next = arrivals
        ?.expand((a) => a.etaSecs)
        .fold<int?>(null, (m, s) => m == null || s < m ? s : m);
    return MetroCard(
      padding: const EdgeInsets.fromLTRB(
        MetroSpacing.md,
        MetroSpacing.sm,
        MetroSpacing.xs,
        MetroSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(station.name, style: context.text.titleMedium),
              ),
              if (next != null)
                Padding(
                  padding: const EdgeInsets.only(left: MetroSpacing.xs),
                  child: Text(
                    context.l10n.nextTrainIn(
                      ArrivalsCard.eta(context.l10n, next),
                    ),
                    style: context.text.labelMedium?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(LucideIcons.x),
                onPressed: onClose,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: MetroSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: MetroSpacing.xxs,
                    runSpacing: MetroSpacing.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final l in catalog.linesOf(station))
                        LineChip(line: l.badge),
                      Text(
                        station.structureLabel,
                        style: context.text.labelSmall,
                      ),
                    ],
                  ),
                ),
                MetroSpacing.gapXs,
                MetroButton(
                  label: context.l10n.details,
                  size: MetroButtonSize.sm,
                  onPressed: () =>
                      context.push(Routes.stationDetail(station.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
