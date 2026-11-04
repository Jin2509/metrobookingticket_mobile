import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Khung chung của P33: Futu kèm icon kết quả, tiêu đề, mô tả, các nút.
class ResultPanel extends StatelessWidget {
  const ResultPanel({
    required this.icon,
    required this.color,
    required this.title,
    this.message,
    required this.actions,
    this.mood = MascotMood.normal,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? message;
  final List<Widget> actions;
  final MascotMood mood;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MetroSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                MetroMascot(
                  size: 112,
                  mood: mood,
                  celebrate: mood == MascotMood.happy,
                ),
                Positioned(
                  right: -8,
                  top: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.metro.card,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(MetroSpacing.xxs),
                      child: Icon(icon, size: 28, color: color),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MetroSpacing.gapLg,
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.text.titleLarge,
          ),
          if (message != null) ...[
            MetroSpacing.gapXs,
            Text(
              message!,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium,
            ),
          ],
          MetroSpacing.gapXl,
          for (final a in actions) ...[a, MetroSpacing.gapSm],
        ],
      ),
    );
  }
}
