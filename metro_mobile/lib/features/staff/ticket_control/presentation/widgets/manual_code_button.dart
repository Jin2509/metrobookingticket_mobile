import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/manual_code_sheet.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[ Nhập mã vé thủ công ]` – dự phòng khi QR hỏng (A3).
class ManualCodeButton extends StatelessWidget {
  const ManualCodeButton({required this.onSubmit, super.key});

  final ValueChanged<String> onSubmit;

  Future<void> _open(BuildContext context) async {
    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ManualCodeSheet(),
    );
    if (code != null && code.trim().isNotEmpty) onSubmit(code);
  }

  @override
  Widget build(BuildContext context) {
    return MetroButton(
      label: context.l10n.manualCode,
      icon: LucideIcons.keyboard,
      variant: MetroButtonVariant.outline,
      expand: true,
      onPressed: () => _open(context),
    );
  }
}
