import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `☐ Dùng 100 điểm   -1.000 ₫` (UC11), cả hàng bấm được, có nhãn.
class LoyaltyPointsToggle extends StatelessWidget {
  const LoyaltyPointsToggle({
    required this.points,
    required this.value,
    required this.available,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final int points;
  final int value;
  final int available;
  final bool enabled;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return CheckboxListTile(
      value: enabled,
      onChanged: (_) => onChanged(),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: Text(
        context.l10n.usePoints(points),
        style: context.text.bodyMedium,
      ),
      subtitle: Text(
        context.l10n.pointsAvailable(count(available)),
        style: context.text.bodySmall,
      ),
      secondary: Text(
        '-${money(value)}',
        style: context.text.bodyMedium?.copyWith(
          color: enabled ? m.success : m.mutedForeground,
        ),
      ),
    );
  }
}
