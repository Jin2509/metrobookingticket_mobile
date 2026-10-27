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

/// Tài khoản nhận + nội dung chuyển khoản (SePay). SePay nhận biến động
/// số dư, khớp [content] với đơn rồi gọi webhook backend → đơn SUCCESS.
@immutable
class BankTransfer {
  const BankTransfer({
    required this.bankBin,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.content,
  });

  /// Mã BIN NAPAS của ngân hàng, VD `970422` (MB Bank).
  final String bankBin;
  final String bankName;
  final String accountNumber;
  final String accountName;

  /// Nội dung chuyển khoản bắt buộc, VD `DH80021`.
  final String content;
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
    this.transfer,
  });

  final String orderId;
  final String orderCode;
  final int amount;

  /// Chuỗi VietQR (SePay) để vẽ mã QR.
  final String qrContent;
  final DateTime expiresAt;

  /// Thông tin để chuyển khoản tay khi không quét được (cùng máy).
  final BankTransfer? transfer;
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
