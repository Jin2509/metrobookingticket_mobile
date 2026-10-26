import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Biển số VN, tự viết hoa. Xe đạp không cần biển số.
class PlateField extends StatefulWidget {
  const PlateField({
    required this.enabled,
    required this.error,
    required this.onChanged,
    super.key,
  });

  final bool enabled;
  final String? error;
  final ValueChanged<String> onChanged;

  @override
  State<PlateField> createState() => _PlateFieldState();
}

class _PlateFieldState extends State<PlateField> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MetroTextField(
      label: context.l10n.plate,
      hint: widget.enabled ? '59X1-234.56' : context.l10n.bicycleNoPlate,
      prefixIcon: LucideIcons.idCard,
      controller: _ctrl,
      enabled: widget.enabled,
      error: widget.enabled ? widget.error : null,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9.\-]')),
        LengthLimitingTextInputFormatter(12),
        TextInputFormatter.withFunction(
          (_, v) => v.copyWith(text: v.text.toUpperCase()),
        ),
      ],
      onChanged: widget.onChanged,
    );
  }
}
