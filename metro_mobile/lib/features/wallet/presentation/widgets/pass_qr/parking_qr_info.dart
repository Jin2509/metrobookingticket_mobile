import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/wallet_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Biển số, loại xe, bãi, thời gian, trạng thái gửi xe.
class ParkingQrInfo extends StatelessWidget {
  const ParkingQrInfo({required this.pass, super.key});

  final ParkingPass pass;

  @override
  Widget build(BuildContext context) {
    final p = pass;
    return Column(
      children: [
        Text(p.plate, style: context.text.titleLarge),
        Text(
          '${vehicleKindOf(p.vehicleCode).label(context.l10n)} · ${p.lotName}',
          style: context.text.bodyLarge,
        ),
        MetroSpacing.gapXs,
        if (p.since != null)
          Text(
            context.l10n.enteredAt(dateTime(p.since!)),
            style: context.text.bodySmall,
          ),
        Text(
          context.l10n.validUntil(dateTime(p.validUntil)),
          style: context.text.bodySmall,
        ),
        MetroSpacing.gapSm,
        StatusBadge(status: p.status),
      ],
    );
  }
}
