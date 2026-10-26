import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/payment_result/result_panel.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// ✅ Thanh toán thành công + [Mở QR vé] (chạm 3).
class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({required this.ticketId, this.parkingId, super.key});

  final String? ticketId;

  /// Đơn gửi xe: mở QR gửi xe thay cho QR vé.
  final String? parkingId;

  @override
  Widget build(BuildContext context) {
    return ResultPanel(
      icon: LucideIcons.circleCheck,
      color: context.metro.success,
      title: context.l10n.paymentSuccess,
      message: parkingId == null
          ? context.l10n.paymentSuccessTicket
          : context.l10n.paymentSuccessParking,
      actions: [
        if (parkingId != null)
          MetroButton(
            label: context.l10n.openParkingQr,
            icon: LucideIcons.qrCode,
            size: MetroButtonSize.lg,
            expand: true,
            onPressed: () => context.go(Routes.parkingPass(parkingId!)),
          ),
        if (ticketId != null)
          MetroButton(
            label: context.l10n.openTicketQr,
            icon: LucideIcons.qrCode,
            size: MetroButtonSize.lg,
            expand: true,
            onPressed: () => context.go(Routes.ticketDetail(ticketId!)),
          ),
        MetroButton(
          label: context.l10n.backHome,
          variant: MetroButtonVariant.ghost,
          expand: true,
          onPressed: () => context.go(Routes.pHome),
        ),
      ],
    );
  }
}
