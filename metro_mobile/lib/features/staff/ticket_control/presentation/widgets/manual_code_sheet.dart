import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Sheet nhập mã vé; trả mã qua `Navigator.pop`. Tự quản lý controller
/// để không bị dispose khi sheet còn đang đóng.
class ManualCodeSheet extends StatefulWidget {
  const ManualCodeSheet({super.key});

  @override
  State<ManualCodeSheet> createState() => _ManualCodeSheetState();
}

class _ManualCodeSheetState extends State<ManualCodeSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _ctrl.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MetroSpacing.lg,
        0,
        MetroSpacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + MetroSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.enterTicketCode, style: context.text.titleLarge),
          MetroSpacing.gapSm,
          MetroTextField(
            hint: context.l10n.ticketCodeExample('VE-80021'),
            controller: _ctrl,
            onSubmitted: (_) => _submit(),
          ),
          MetroSpacing.gapMd,
          MetroButton(
            label: context.l10n.check,
            expand: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
