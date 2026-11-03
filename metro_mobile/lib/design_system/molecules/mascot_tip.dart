import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/metro_mascot.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Luke hướng dẫn bước hiện tại bằng bong bóng thoại.
class MascotTip extends StatelessWidget {
  const MascotTip({
    required this.text,
    this.mood = MascotMood.normal,
    super.key,
  });

  final String text;
  final MascotMood mood;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ExcludeSemantics(child: MetroMascot(size: 52, mood: mood)),
        MetroSpacing.gapXs,
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.metro.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MetroRadius.lg),
                topRight: Radius.circular(MetroRadius.lg),
                bottomRight: Radius.circular(MetroRadius.lg),
                bottomLeft: Radius.circular(MetroSpacing.xxs),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: MetroSpacing.sm,
                vertical: MetroSpacing.xs,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  text,
                  key: ValueKey(text),
                  style: context.text.bodyMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
