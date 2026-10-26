import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/atoms/password_strength.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thanh 4 vạch `▓▓▓░ Mạnh vừa` (wireframe A2).
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({required this.strength, super.key});

  final PasswordStrength strength;

  Color _color(MetroColorsExt m) => switch (strength) {
    PasswordStrength.empty => m.muted,
    PasswordStrength.weak => m.destructive,
    PasswordStrength.fair => m.accent,
    PasswordStrength.good || PasswordStrength.strong => m.success,
  };

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final active = _color(m);
    return Row(
      children: [
        for (var i = 1; i <= 4; i++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              decoration: BoxDecoration(
                color: i <= strength.level ? active : m.muted,
                borderRadius: MetroRadius.brPill,
              ),
            ),
          ),
          MetroSpacing.gapXxs,
        ],
        SizedBox(
          width: 76,
          child: Text(
            strength.label(context.l10n),
            textAlign: TextAlign.end,
            style: context.text.labelSmall?.copyWith(color: active),
          ),
        ),
      ],
    );
  }
}
