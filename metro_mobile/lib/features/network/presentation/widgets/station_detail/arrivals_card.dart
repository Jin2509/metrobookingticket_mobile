import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/station_arrivals_provider.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Tàu sắp đến: → Suối Tiên  2 ph · 10 ph` (realtime, P22).
class ArrivalsCard extends ConsumerWidget {
  const ArrivalsCard({
    required this.stationId,
    required this.catalog,
    this.title,
    super.key,
  });

  final String stationId;
  final NetworkCatalog catalog;

  /// Trang chủ dùng `Tàu sắp đến · Ga …`.
  final String? title;

  static String eta(AppLocalizations l, int sec) =>
      sec < 60 ? l.arriving : l.etaMinutes((sec / 60).ceil());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tab bị ẩn (TickerMode tắt) thì không nghe WebSocket.
    final arrivals = TickerMode.valuesOf(context).enabled
        ? ref.watch(stationArrivalsProvider(stationId))
        : const AsyncValue<List<Arrival>>.loading();
    return SectionCard(
      title: title ?? context.l10n.nextTrains,
      child: arrivals.when(
        loading: () => const MetroSkeleton(height: 40),
        error: (_, _) =>
            Text(context.l10n.arrivalsFailed, style: context.text.bodySmall),
        data: (list) => list.isEmpty
            ? Text(context.l10n.noArrivals, style: context.text.bodySmall)
            : Column(children: [for (final a in list) _ArrivalRow(a, catalog)]),
      ),
    );
  }
}

class _ArrivalRow extends StatelessWidget {
  const _ArrivalRow(this.arrival, this.catalog);
  final Arrival arrival;
  final NetworkCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final name = catalog.station(arrival.headsignStationId)?.name ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
      child: Row(
        children: [
          Icon(LucideIcons.arrowRight, size: 16, color: context.colors.primary),
          MetroSpacing.gapXs,
          Expanded(child: Text(name, style: context.text.bodyLarge)),
          Text(
            arrival.etaSecs
                .map((s) => ArrivalsCard.eta(context.l10n, s))
                .join(' · '),
            style: context.text.titleSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
