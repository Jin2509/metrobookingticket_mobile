import 'package:flutter/foundation.dart';

/// Giao dịch cá nhân (UC9-01, P52).
@immutable
class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.orderCode,
    required this.title,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String orderCode;
  final String title;
  final int amount;
  final String method;

  /// SUCCESS, FAILED, REFUNDED, PENDING.
  final String status;
  final DateTime createdAt;
}
