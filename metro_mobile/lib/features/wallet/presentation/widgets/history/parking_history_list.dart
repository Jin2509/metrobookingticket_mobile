import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/wallet_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Lượt gửi xe đã kết thúc. QR không còn dùng được nên không có nút mở.
class ParkingHistoryList extends ConsumerWidget {
  const ParkingHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView(
      value: ref.watch(parkingHistoryProvider),
      onRetry: () => ref.invalidate(parkingHistoryProvider),
      data: (list) => list.isEmpty
          ? EmptyState(
              icon: LucideIcons.squareParking,
              title: context.l10n.noParkingHistory,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(MetroSpacing.md),
              itemCount: list.length,
              separatorBuilder: (_, _) => MetroSpacing.gapSm,
              itemBuilder: (_, i) => ParkingPassCard(
                lotName: list[i].lotName,
                plate: list[i].plate,
                vehicle: vehicleKindOf(list[i].vehicleCode),
                status: list[i].status,
                since: list[i].since,
              ),
            ),
    );
  }
}
