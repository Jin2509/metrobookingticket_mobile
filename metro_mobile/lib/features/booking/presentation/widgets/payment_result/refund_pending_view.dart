import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/payment_result/result_panel.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A4: đã trừ tiền nhưng lỗi tạo vé → "Đang xử lý hoàn tiền" + mã tra soát.
class RefundPendingView extends StatelessWidget {
  const RefundPendingView({required this.refundCode, super.key});

  final String? refundCode;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ResultPanel(
      icon: LucideIcons.hourglass,
      color: context.metro.accent,
      title: l.refundPendingTitle,
      message: [
        l.refundPendingBody,
        if (refundCode != null) l.refundCode(refundCode!),
      ].join('\n'),
      actions: [
        MetroButton(
          label: l.viewTransactions,
          variant: MetroButtonVariant.outline,
          expand: true,
          onPressed: () => context.go(Routes.pTransactions),
        ),
        MetroButton(
          label: l.backHome,
          variant: MetroButtonVariant.ghost,
          expand: true,
          onPressed: () => context.go(Routes.pHome),
        ),
      ],
    );
  }
}
