import 'package:flutter/foundation.dart';

enum StudentStatus {
  none,

  /// Đã gửi thẻ, đang chờ duyệt.
  pending,
  verified,
  rejected,

  /// Đã qua thời hạn hiệu lực, cần xác nhận lại.
  expired;

  static StudentStatus parse(String? v) => switch (v) {
    'VERIFIED' => verified,
    'PENDING' => pending,
    'REJECTED' => rejected,
    'EXPIRED' => expired,
    _ => none,
  };
}

/// Xác nhận sinh viên của tài khoản. Backend đọc thẻ, duyệt và áp giá; app chỉ
/// hiển thị. Mỗi lần được duyệt có hiệu lực 1 năm.
@immutable
class StudentVerification {
  const StudentVerification({
    required this.status,
    this.fullName,
    this.school,
    this.studentCode,
    this.expiresAt,
    this.submittedAt,
    this.reason,
  });

  factory StudentVerification.fromJson(Map<String, Object?> j) {
    DateTime? at(String key) {
      final v = j[key] as String?;
      return v == null ? null : DateTime.parse(v);
    }

    return StudentVerification(
      status: StudentStatus.parse(j['status'] as String?),
      fullName: j['fullName'] as String?,
      school: j['school'] as String?,
      studentCode: j['studentCode'] as String?,
      expiresAt: at('expiresAt'),
      submittedAt: at('submittedAt'),
      reason: j['reason'] as String?,
    );
  }

  static const none = StudentVerification(status: StudentStatus.none);

  /// Báo trước khi hết hạn để kịp gửi lại, vì duyệt cần thời gian.
  static const renewWithinDays = 30;

  final StudentStatus status;
  final String? fullName;
  final String? school;
  final String? studentCode;

  /// Ưu đãi dùng được tới mốc này, kể cả khi đang chờ duyệt lần gia hạn.
  final DateTime? expiresAt;
  final DateTime? submittedAt;

  /// Lý do bị từ chối hoặc hết hạn, backend soạn sẵn.
  final String? reason;

  bool isActive(DateTime now) => expiresAt?.isAfter(now) ?? false;

  int daysLeft(DateTime now) => expiresAt?.difference(now).inDays ?? 0;

  bool expiringSoon(DateTime now) =>
      status == StudentStatus.verified &&
      isActive(now) &&
      daysLeft(now) <= renewWithinDays;
}
