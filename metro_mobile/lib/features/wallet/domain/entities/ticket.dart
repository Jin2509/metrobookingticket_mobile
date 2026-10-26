import 'package:flutter/foundation.dart';

/// Vé đã mua (`ticket`). [qrToken] là thứ duy nhất được mã hóa vào QR.
@immutable
class Ticket {
  const Ticket({
    required this.id,
    required this.code,
    required this.typeCode,
    required this.typeName,
    required this.status,
    required this.price,
    required this.validFrom,
    required this.validUntil,
    required this.purchasedAt,
    required this.qrToken,
    this.fromName,
    this.toName,
  });

  final String id;

  /// `VE-80021`.
  final String code;
  final String typeCode;
  final String typeName;

  /// Mã theo CHECK constraint: PAID, IN_USE, USED, EXPIRED, ...
  final String status;
  final int price;
  final DateTime validFrom;
  final DateTime validUntil;
  final DateTime purchasedAt;
  final String qrToken;

  /// Chỉ có ở vé lượt.
  final String? fromName;
  final String? toName;

  /// Còn dùng được để vào/ra ga.
  bool get isUsable => status == 'PAID' || status == 'IN_USE';

  bool get hasRoute => fromName != null && toName != null;
}
