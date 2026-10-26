import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/payment_result/result_panel.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// ❌ Thanh toán thất bại / hết hạn + [Thử lại] (A2).
class PaymentFailedView extends StatelessWidget {
  const PaymentFailedView({required this.expired, super.key});

  final bool expired;

  @override
  Widget build(BuildContext context) {
    return ResultPanel(
      icon: LucideIcons.circleX,
      color: context.metro.destructive,
      title: expired
          ? context.l10n.paymentCodeExpired
          : context.l10n.paymentFailed,
      message: context.l10n.paymentFailedBody,
      actions: [
        MetroButton(
          label: context.l10n.retry,
          icon: LucideIcons.refreshCw,
          size: MetroButtonSize.lg,
          expand: true,
          onPressed: () => context.go(Routes.pHome),
        ),
      ],
    );
  }
}
