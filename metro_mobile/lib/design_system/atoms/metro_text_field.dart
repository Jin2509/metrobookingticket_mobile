import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ô nhập có nhãn phía trên (wireframe A1/A2), giống `ui/input.tsx`.
class MetroTextField extends StatelessWidget {
  const MetroTextField({
    this.label,
    this.hint,
    this.error,
    this.prefixIcon,
    this.suffix,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final String? label;
  final String? hint;
  final String? error;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: context.text.labelMedium),
          MetroSpacing.gapXs,
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          enabled: enabled,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: context.text.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            errorText: error == null
                ? null
                : localizeMessage(context.l10n, error!),
            errorStyle: context.text.labelSmall?.copyWith(color: m.destructive),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 20, color: m.mutedForeground),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
