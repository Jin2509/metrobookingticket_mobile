import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `☐ Tôi đồng ý với Điều khoản sử dụng` (cả hàng bấm được).
class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: Text.rich(
        TextSpan(
          text: context.l10n.agreeTo,
          children: [
            TextSpan(
              text: context.l10n.termsOfUse,
              style: TextStyle(color: context.colors.primary),
            ),
          ],
        ),
        style: context.text.bodyMedium,
      ),
    );
  }
}
