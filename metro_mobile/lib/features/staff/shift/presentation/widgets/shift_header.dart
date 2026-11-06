import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_providers.dart';
import 'package:metro_mobile/features/staff/shift/domain/entities/staff_shift.dart';
import 'package:metro_mobile/features/staff/shift/presentation/controllers/shift_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Số nhân viên tại ga`: chỉ hiện mốc giới hạn khi hệ thống có đặt.
String? staffCountLabel(AppLocalizations l, StaffShift s) {
  final on = s.staffOnDuty;
  if (on == null) return null;
  final limit = s.staffLimit;
  return limit == null ? l.staffOnDuty(on) : l.staffOnDutyLimit(on, limit);
}

/// Ga đang phụ trách, luôn nằm đầu các màn nhân viên. [showLot]: màn gửi xe nên
/// hiện tên bãi thay cho ca làm.
class ShiftHeader extends ConsumerWidget {
  const ShiftHeader({this.showLot = false, this.showActions = true, super.key});

  final bool showLot;

  /// Nút mở Sự cố tại ga, ẩn khi đang ở ngay màn sự cố.
  final bool showActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(shiftProvider).value;
    if (s == null) return const MetroSkeleton(height: 48);
    final l = context.l10n;
    final subtitle = showLot
        ? s.lotName
        : [l.shiftLine(s.shiftLabel), ?staffCountLabel(l, s)].join(' · ');
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: .18),
            borderRadius: MetroRadius.brLg,
          ),
          child: SizedBox.square(
            dimension: 44,
            child: Icon(LucideIcons.mapPin, color: context.colors.primary),
          ),
        ),
        MetroSpacing.gapSm,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.stationName(s.stationName),
                style: context.text.titleMedium,
              ),
              Text(subtitle, style: context.text.bodySmall),
            ],
          ),
        ),
        if (showActions)
          MetroIconButton(
            icon: LucideIcons.triangleAlert,
            color: context.metro.accent,
            tooltip: l.incidentListTitle,
            badgeCount: ref.watch(openIncidentCountProvider),
            onPressed: () => context.push(Routes.sIncidents),
          ),
      ],
    );
  }
}
