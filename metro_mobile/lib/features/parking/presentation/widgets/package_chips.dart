import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/presentation/mappers/parking_labels.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Lượt)(Ngày)(Tháng)`.
class PackageChips extends StatelessWidget {
  const PackageChips({required this.value, required this.onChanged, super.key});

  final ParkingPackage value;
  final ValueChanged<ParkingPackage> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MetroSpacing.xs,
      children: [
        for (final p in ParkingPackage.values)
          ChoiceChip(
            label: Text(parkingPackageLabel(context.l10n, p)),
            showCheckmark: false,
            selected: p == value,
            onSelected: (_) => onChanged(p),
          ),
      ],
    );
  }
}
