import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/live_trains_controllers.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/presentation/mappers/diagram_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Danh sách ga theo `station_order` dạng LineDiagram, có tàu đang tới.
class LineStationsCard extends ConsumerWidget {
  const LineStationsCard({
    required this.catalog,
    required this.line,
    super.key,
  });

  final NetworkCatalog catalog;
  final MetroLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trains = line.isPlanned || !TickerMode.valuesOf(context).enabled
        ? null
        : ref.watch(lineTrainsProvider(line.id)).value;
    return MetroCard(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xs),
      child: LineDiagram(
        stops: lineDiagramStops(
          context.l10n,
          catalog,
          line,
          trains: trains ?? const [],
        ),
        onTapStop: (id) => context.push(Routes.stationDetail(id)),
      ),
    );
  }
}
