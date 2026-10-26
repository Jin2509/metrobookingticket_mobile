import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/payment_controller.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/payment_qr_body.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P31/P32. QR thanh toán 10:00; có kết quả thì sang P33.
class PaymentQrScreen extends ConsumerWidget {
  const PaymentQrScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(paymentControllerProvider(orderId).select((s) => s.update), (
      _,
      u,
    ) {
      if (u == null || !u.status.isTerminal) return;
      if (u.status == PaymentStatus.cancelled) return;
      context.pushReplacement(
        Routes.paymentResult(
          orderId,
          u.status.name,
          ticketId: u.ticketId,
          parkingId: u.parkingId,
          refundCode: u.refundCode,
        ),
      );
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          unawaited(PaymentQrBody.confirmCancel(context, ref, orderId));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.pay)),
        body: PaymentQrBody(orderId: orderId),
      ),
    );
  }
}
