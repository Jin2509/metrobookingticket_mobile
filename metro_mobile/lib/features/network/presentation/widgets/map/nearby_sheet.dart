import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_panel_controller.dart';
import 'package:metro_mobile/features/network/presentation/controllers/nearby_controller.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/map_places_panel.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/nearby_sheet_content.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Sheet kéo trên bản đồ, gộp Ga gần bạn (P24) và Quanh ga (P27).
class NearbySheet extends ConsumerStatefulWidget {
  const NearbySheet({
    this.autoLocate = false,
    this.initialPanel = MapPanel.nearby,
    this.stationId,
    super.key,
  });

  /// Mở từ lối tắt "Ga gần bạn" thì xin vị trí ngay.
  final bool autoLocate;
  final MapPanel initialPanel;
  final String? stationId;

  @override
  ConsumerState<NearbySheet> createState() => _NearbySheetState();
}

class _NearbySheetState extends ConsumerState<NearbySheet> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future.microtask(() {
        if (!mounted) return;
        final panel = ref.read(mapPanelProvider.notifier);
        if (widget.stationId case final id?) {
          panel.selectStation(id);
        }
        panel.show(widget.initialPanel);
        if (widget.autoLocate) {
          unawaited(ref.read(nearbyControllerProvider.notifier).locate());
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final l = context.l10n;
    final panel = ref.watch(mapPanelProvider.select((s) => s.panel));
    return DraggableScrollableSheet(
      initialChildSize: widget.initialPanel == MapPanel.places ? .45 : .32,
      minChildSize: .16,
      maxChildSize: .75,
      builder: (context, scroll) => DecoratedBox(
        decoration: BoxDecoration(
          color: m.card,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(MetroRadius.xxl),
          ),
          boxShadow: const [
            BoxShadow(blurRadius: 12, color: MetroColors.shadow),
          ],
        ),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.only(bottom: MetroSpacing.lg),
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: MetroSpacing.xs),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: m.border,
                  borderRadius: MetroRadius.brPill,
                ),
              ),
            ),
            Padding(
              padding: MetroSpacing.screenPadding,
              child: SegmentedButton<MapPanel>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: MapPanel.nearby,
                    label: Text(l.nearbyStations),
                  ),
                  ButtonSegment(
                    value: MapPanel.places,
                    label: Text(l.tabNearby),
                  ),
                ],
                selected: {panel},
                onSelectionChanged: (s) =>
                    ref.read(mapPanelProvider.notifier).show(s.first),
              ),
            ),
            MetroSpacing.gapSm,
            if (panel == MapPanel.nearby)
              const NearbySheetContent()
            else
              const MapPlacesPanel(),
          ],
        ),
      ),
    );
  }
}
