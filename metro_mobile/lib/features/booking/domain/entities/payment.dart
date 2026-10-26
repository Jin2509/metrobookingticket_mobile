import 'package:flutter/foundation.dart';

enum PaymentStatus {
  pending,
  success,
  failed,
  expired,
  cancelled,

  /// A4: đã trừ tiền nhưng tạo vé lỗi → đang hoàn tiền.
  refundPending;

  bool get isTerminal => this != PaymentStatus.pending;

  static PaymentStatus parse(String? v) => switch (v) {
    'SUCCESS' => success,
    'FAILED' => failed,
    'EXPIRED' => expired,
    'CANCELLED' => cancelled,
    'REFUND_PENDING' => refundPending,
    _ => pending,
  };
}

/// QR thanh toán có hiệu lực 10 phút (mục 10.2).
@immutable
class PaymentSession {
  const PaymentSession({
    required this.orderId,
    required this.orderCode,
    required this.amount,
    required this.qrContent,
    required this.expiresAt,
  });

  final String orderId;
  final String orderCode;
  final int amount;

  /// Nội dung VietQR/MoMo/VNPay của cổng thanh toán (Q2).
  final String qrContent;
  final DateTime expiresAt;
}

/// Gói tin `/user/queue/payments` hoặc kết quả poll.
@immutable
class PaymentUpdate {
  const PaymentUpdate({
    required this.orderId,
    required this.status,
    this.ticketId,
    this.parkingId,
    this.refundCode,
  });

  final String orderId;
  final PaymentStatus status;

  /// Có khi SUCCESS: mở QR vé ngay.
  final String? ticketId;

  /// Có khi đơn gửi xe SUCCESS: mở QR gửi xe.
  final String? parkingId;

  /// Mã tra soát khi đang hoàn tiền (A4).
  final String? refundCode;
}
