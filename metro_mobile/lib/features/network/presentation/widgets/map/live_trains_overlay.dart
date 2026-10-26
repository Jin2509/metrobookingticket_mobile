import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/live_trains_controllers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_filter_controller.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';

/// Lớp tàu realtime trên bản đồ. Chỉ widget này rebuild mỗi giây khi
/// vị trí nội suy đổi; marker ga và polyline giữ nguyên (mục 9, Prompt 13).
class LiveTrainsOverlay extends ConsumerWidget {
  const LiveTrainsOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider).value;
    final filter = ref.watch(mapFilterProvider);
    if (catalog == null || !TickerMode.valuesOf(context).enabled) {
      return const SizedBox.shrink();
    }
    final trains = [
      for (final l in catalog.lines)
        if (!l.isPlanned && filter.shows(l.id))
          ...ref.watch(animatedTrainsProvider(l.id)),
    ];
    return LiveTrainLayer(trains: catalog.mapTrains(trains));
  }
}
