import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Lối tắt Trang chủ: Mua vé (mọi loại), Sơ đồ tuyến, Quanh ga, Gửi xe.
class HomeQuickActions extends ConsumerWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final from = ref.watch(quickBookProvider.select((s) => s.fromId));
    return QuickActionGrid(
      actions: [
        QuickAction(
          LucideIcons.ticketPlus,
          l.buyTicket,
          () => context.push(Routes.buy()),
        ),
        QuickAction(
          LucideIcons.waypoints,
          l.lineDiagram,
          () => context.go(Routes.pExplore),
        ),
        QuickAction(
          LucideIcons.mapPinned,
          l.tabNearby,
          () => context.push(Routes.places(stationId: from)),
        ),
        QuickAction(
          LucideIcons.circleParking,
          l.navParking,
          () => context.push(Routes.pParkingBook),
        ),
      ],
    );
  }
}
