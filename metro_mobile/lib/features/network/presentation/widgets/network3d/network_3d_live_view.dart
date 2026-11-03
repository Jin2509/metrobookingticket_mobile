import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/live_trains_controllers.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Sơ đồ 3D kèm tàu đang chạy. Tách riêng để chỉ phần này dựng lại theo tàu.
/// Chưa nối WebSocket thì ghi rõ là mô phỏng, không nói là dữ liệu thật.
class Network3dLiveView extends ConsumerWidget {
  const Network3dLiveView({
    required this.catalog,
    required this.selectedId,
    required this.lineId,
    required this.onStationTap,
    super.key,
  });

  final NetworkCatalog catalog;
  final String? selectedId;
  final String? lineId;
  final ValueChanged<String> onStationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final trains = [
      for (final line in catalog.lines)
        if (!line.isPlanned && (lineId == null || line.id == lineId))
          ...ref.watch(animatedTrainsProvider(line.id)),
    ];
    return Stack(
      children: [
        Positioned.fill(
          child: Network3dView(
            lines: catalog.diagramLines,
            selectedId: selectedId,
            visibleLineIds: lineId == null ? null : {lineId!},
            resetTooltip: l.network3dReset,
            onStationTap: onStationTap,
            trains: catalog.diagramTrains(trains),
          ),
        ),
        if (trains.isNotEmpty)
          Positioned(
            left: MetroSpacing.md,
            top: MetroSpacing.md,
            child: Semantics(
              liveRegion: false,
              child: Text(
                Env.wsUrl.isEmpty
                    ? l.trainsSimulated(trains.length)
                    : l.trainsLive(trains.length),
                style: context.text.labelMedium,
              ),
            ),
          ),
      ],
    );
  }
}
