import 'package:flutter/foundation.dart';

enum QrKind { ticket, parking }

/// Nội dung QR vé / lượt gửi xe. Chỉ chứa token, không chứa PII (P5).
@immutable
class QrPayload {
  const QrPayload({
    required this.kind,
    required this.token,
    required this.issuedAt,
  });

  final QrKind kind;
  final String token;
  final DateTime issuedAt;

  @override
  bool operator ==(Object other) =>
      other is QrPayload &&
      other.kind == kind &&
      other.token == token &&
      other.issuedAt == issuedAt;

  @override
  int get hashCode => Object.hash(kind, token, issuedAt);

  @override
  String toString() => 'QrPayload($kind, $token)';
}
