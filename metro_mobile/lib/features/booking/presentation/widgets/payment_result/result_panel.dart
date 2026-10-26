import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Khung chung của P33: icon tròn, tiêu đề, mô tả, các nút.
class ResultPanel extends StatelessWidget {
  const ResultPanel({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.actions,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MetroSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: color),
            ),
          ),
          MetroSpacing.gapLg,
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.text.titleLarge,
          ),
          MetroSpacing.gapXs,
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
          MetroSpacing.gapXl,
          for (final a in actions) ...[a, MetroSpacing.gapSm],
        ],
      ),
    );
  }
}
