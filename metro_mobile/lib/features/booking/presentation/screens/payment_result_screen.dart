import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/payment_result/payment_failed_view.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/payment_result/payment_success_view.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/payment_result/refund_pending_view.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';

/// P33. Kết quả thanh toán. Thành công thì làm mới danh sách vé.
class PaymentResultScreen extends ConsumerStatefulWidget {
  const PaymentResultScreen({
    required this.status,
    this.ticketId,
    this.parkingId,
    this.refundCode,
    super.key,
  });

  final PaymentStatus status;
  final String? ticketId;
  final String? parkingId;
  final String? refundCode;

  @override
  ConsumerState<PaymentResultScreen> createState() => _ResultState();
}

class _ResultState extends ConsumerState<PaymentResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refreshWallet(ref));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: switch (widget.status) {
          PaymentStatus.success => PaymentSuccessView(
            ticketId: widget.ticketId,
            parkingId: widget.parkingId,
          ),
          PaymentStatus.refundPending => RefundPendingView(
            refundCode: widget.refundCode,
          ),
          _ => PaymentFailedView(
            expired: widget.status == PaymentStatus.expired,
          ),
        },
      ),
    );
  }
}
