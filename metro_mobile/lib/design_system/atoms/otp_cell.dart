import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Một ô số trong `OtpInput`.
class OtpCell extends StatelessWidget {
  const OtpCell({
    required this.digit,
    required this.focused,
    required this.hasError,
    super.key,
  });

  final String digit;
  final bool focused;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final borderColor = hasError
        ? m.destructive
        : focused
        ? context.colors.primary
        : m.border;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 46,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: m.card,
        borderRadius: MetroRadius.brLg,
        border: Border.all(color: borderColor, width: focused ? 2 : 1),
      ),
      child: Text(
        digit,
        style: MetroTypography.title.copyWith(color: context.colors.onSurface),
      ),
    );
  }
}
