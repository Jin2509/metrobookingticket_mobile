import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/metro_text_field.dart';
import 'package:metro_mobile/design_system/atoms/password_strength.dart';
import 'package:metro_mobile/design_system/atoms/password_strength_bar.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ô mật khẩu có nút hiện/ẩn và (tùy chọn) thanh đo độ mạnh.
class PasswordField extends StatefulWidget {
  const PasswordField({
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.showStrength = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  /// Mặc định "Mật khẩu".
  final String? label;
  final String? hint;
  final String? error;
  final TextEditingController? controller;
  final bool showStrength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;
  late PasswordStrength _strength = PasswordStrength.of(
    widget.controller?.text ?? '',
  );

  void _onChanged(String value) {
    if (widget.showStrength) {
      setState(() => _strength = PasswordStrength.of(value));
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        MetroTextField(
          label: widget.label ?? context.l10n.password,
          hint: widget.hint,
          error: widget.error,
          controller: widget.controller,
          obscureText: _obscure,
          textInputAction: widget.textInputAction,
          autofillHints: const [AutofillHints.password],
          onChanged: _onChanged,
          onSubmitted: widget.onSubmitted,
          suffix: IconButton(
            tooltip: _obscure
                ? context.l10n.showPassword
                : context.l10n.hidePassword,
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure ? LucideIcons.eye : LucideIcons.eyeOff,
              size: 20,
              color: context.metro.mutedForeground,
            ),
          ),
        ),
        if (widget.showStrength) ...[
          MetroSpacing.gapXs,
          PasswordStrengthBar(strength: _strength),
        ],
      ],
    );
  }
}
