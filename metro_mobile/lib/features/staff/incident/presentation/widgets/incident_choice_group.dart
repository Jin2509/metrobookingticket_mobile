import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Tiêu đề và nhóm chip chọn một giá trị, dùng cho loại, vị trí, mức độ.
class IncidentChoiceGroup<T> extends StatelessWidget {
  const IncidentChoiceGroup({
    required this.title,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.iconOf,
    super.key,
  });

  final String title;
  final List<T> values;
  final T? selected;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;
  final ValueChanged<T>? onSelected;

  @override
  Widget build(BuildContext context) {
    final icon = iconOf;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.text.titleSmall),
        MetroSpacing.gapXs,
        Wrap(
          spacing: MetroSpacing.xs,
          runSpacing: MetroSpacing.xs,
          children: [
            for (final v in values)
              ChoiceChip(
                avatar: icon == null ? null : Icon(icon(v), size: 16),
                label: Text(labelOf(v)),
                showCheckmark: false,
                selected: v == selected,
                onSelected: onSelected == null ? null : (_) => onSelected!(v),
              ),
          ],
        ),
      ],
    );
  }
}
