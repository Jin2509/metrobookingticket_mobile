import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Một chỉ số nhỏ: giá trị và nhãn. Dùng trong `Row`.
class GreenStat extends StatelessWidget {
  const GreenStat(this.value, this.label, {super.key});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MetroCard(
        padding: const EdgeInsets.all(MetroSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: context.text.titleLarge),
            Text(label, style: context.text.labelSmall),
          ],
        ),
      ),
    );
  }
}
