import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Logo chữ "HopOn" và slogan, kèm linh vật Futu.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MetroMascot(size: 56),
        MetroSpacing.gapSm,
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HopOn',
                style: context.text.titleLarge?.copyWith(
                  color: MetroColors.primaryForeground,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                context.l10n.appSlogan,
                style: context.text.bodySmall?.copyWith(
                  color: context.metro.sidebarForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
