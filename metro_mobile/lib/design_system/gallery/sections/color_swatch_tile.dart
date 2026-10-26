import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

class ColorSwatchTile extends StatelessWidget {
  const ColorSwatchTile({required this.name, required this.color, super.key});

  final String name;
  final Color color;

  String get _hex =>
      '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: MetroRadius.brMd,
              border: Border.all(color: context.metro.border),
            ),
          ),
          MetroSpacing.gapXxs,
          Text(name, style: context.text.labelMedium, maxLines: 1),
          Text(_hex, style: context.text.labelSmall),
        ],
      ),
    );
  }
}
