import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Logo chữ "METRO TP.HCM" kèm linh vật Luke.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MetroMascot(size: 56),
        MetroSpacing.gapSm,
        Text(
          'METRO TP.HCM',
          style: context.text.titleLarge?.copyWith(
            color: MetroColors.primaryForeground,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
