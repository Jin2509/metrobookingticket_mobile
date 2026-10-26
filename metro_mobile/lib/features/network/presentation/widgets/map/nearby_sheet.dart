import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/nearby_controller.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/nearby_sheet_content.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `▔▔ Ga gần bạn` – sheet kéo trên bản đồ (P24).
class NearbySheet extends ConsumerStatefulWidget {
  const NearbySheet({this.autoLocate = false, super.key});

  /// Mở từ lối tắt "Ga gần bạn" thì xin vị trí ngay.
  final bool autoLocate;

  @override
  ConsumerState<NearbySheet> createState() => _NearbySheetState();
}

class _NearbySheetState extends ConsumerState<NearbySheet> {
  @override
  void initState() {
    super.initState();
    if (widget.autoLocate) {
      unawaited(
        Future.microtask(
          () => ref.read(nearbyControllerProvider.notifier).locate(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return DraggableScrollableSheet(
      initialChildSize: .3,
      minChildSize: .14,
      maxChildSize: .65,
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
              child: Text(
                context.l10n.nearbyStations,
                style: context.text.titleMedium,
              ),
            ),
            MetroSpacing.gapXs,
            const NearbySheetContent(),
          ],
        ),
      ),
    );
  }
}
