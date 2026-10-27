import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[Đặt vé từ ga này] [Xem bản đồ]`. Đặt vé mở tra lộ trình với ga đi
/// chọn sẵn; chọn ga đến xong bấm "Đặt vé" ở kết quả.
class StationActionsBar extends StatelessWidget {
  const StationActionsBar({required this.stationId, super.key});

  final String stationId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(MetroSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: MetroButton(
                label: context.l10n.bookFromHere,
                icon: LucideIcons.ticket,
                expand: true,
                onPressed: () => context.push(Routes.buy(from: stationId)),
              ),
            ),
            MetroSpacing.gapSm,
            Expanded(
              child: MetroButton(
                label: context.l10n.viewMap,
                icon: LucideIcons.map,
                variant: MetroButtonVariant.outline,
                expand: true,
                onPressed: () => context.push(Routes.map(stationId: stationId)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
