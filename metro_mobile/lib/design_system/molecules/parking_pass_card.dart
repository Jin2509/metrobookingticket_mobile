import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/atoms/status_badge.dart';
import 'package:metro_mobile/design_system/models/vehicle_kind.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ gửi xe: bãi, biển số, loại xe, thời gian, trạng thái (P42).
class ParkingPassCard extends StatelessWidget {
  const ParkingPassCard({
    required this.lotName,
    required this.plate,
    required this.vehicle,
    required this.status,
    this.since,
    this.onOpenQr,
    super.key,
  });

  final String lotName;
  final String plate;
  final VehicleKind vehicle;

  /// Mã trạng thái gửi xe: `CHUA_GUI`, `DANG_GUI`, `LAY_XE`, `HET_HAN`.
  final String status;
  final DateTime? since;
  final VoidCallback? onOpenQr;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return MetroCard(
      onTap: onOpenQr,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(MetroSpacing.xs),
            decoration: BoxDecoration(
              color: m.secondary,
              borderRadius: MetroRadius.brMd,
            ),
            child: Icon(vehicle.icon, color: context.colors.primary),
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plate, style: context.text.titleSmall),
                Text(
                  '${vehicle.label(context.l10n)} · $lotName',
                  style: context.text.bodySmall,
                ),
                if (since != null)
                  Text(
                    context.l10n.sinceTime(timeOnly(since!)),
                    style: context.text.bodySmall,
                  ),
                MetroSpacing.gapXxs,
                StatusBadge(status: status),
              ],
            ),
          ),
          if (onOpenQr != null)
            MetroButton(
              label: 'QR',
              icon: LucideIcons.qrCode,
              size: MetroButtonSize.sm,
              variant: MetroButtonVariant.outline,
              onPressed: onOpenQr,
            ),
        ],
      ),
    );
  }
}
