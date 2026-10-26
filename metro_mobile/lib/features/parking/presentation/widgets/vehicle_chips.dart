import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Xe máy)(Xe đạp)(Ô tô)`.
class VehicleChips extends StatelessWidget {
  const VehicleChips({required this.value, required this.onChanged, super.key});

  final String value;
  final ValueChanged<String> onChanged;

  static const options = [
    ('MOTORBIKE', VehicleKind.motorbike),
    ('BICYCLE', VehicleKind.bicycle),
    ('CAR', VehicleKind.car),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MetroSpacing.xs,
      children: [
        for (final (code, kind) in options)
          ChoiceChip(
            avatar: Icon(kind.icon, size: 16),
            label: Text(kind.label(context.l10n)),
            showCheckmark: false,
            selected: code == value,
            onSelected: (_) => onChanged(code),
          ),
      ],
    );
  }
}
