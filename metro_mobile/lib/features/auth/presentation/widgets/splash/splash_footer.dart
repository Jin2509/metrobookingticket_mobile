import 'package:flutter/material.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Vòng tải + nhãn môi trường.
class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Column(
      children: [
        SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: m.sidebarPrimary,
          ),
        ),
        MetroSpacing.gapMd,
        Text(
          context.l10n.environment(Env.flavor.toUpperCase()),
          style: context.text.labelSmall?.copyWith(color: m.mutedForeground),
        ),
      ],
    );
  }
}
