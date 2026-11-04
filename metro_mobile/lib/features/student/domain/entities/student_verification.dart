import 'package:flutter/foundation.dart';

enum StudentStatus {
  none,

  /// AI chưa đủ chắc chắn, chờ nhân viên kiểm tra.
  pending,
  verified,
  rejected;

  static StudentStatus parse(String? v) => switch (v) {
    'VERIFIED' => verified,
    'PENDING' => pending,
    'REJECTED' => rejected,
    _ => none,
  };
}

/// Kết quả xác thực sinh viên. Backend đọc ảnh thẻ, đối chiếu và quyết định;
/// app chỉ hiển thị.
@immutable
class StudentVerification {
  const StudentVerification({
    required this.status,
    this.fullName,
    this.school,
    this.studentCode,
    this.validUntil,
    this.reason,
  });

  factory StudentVerification.fromJson(Map<String, Object?> j) {
    final until = j['validUntil'] as String?;
    return StudentVerification(
      status: StudentStatus.parse(j['status'] as String?),
      fullName: j['fullName'] as String?,
      school: j['school'] as String?,
      studentCode: j['studentCode'] as String?,
      validUntil: until == null ? null : DateTime.parse(until),
      reason: j['reason'] as String?,
    );
  }

  static const none = StudentVerification(status: StudentStatus.none);

  final StudentStatus status;
  final String? fullName;
  final String? school;
  final String? studentCode;
  final DateTime? validUntil;

  /// Lý do chờ kiểm tra hoặc bị từ chối, backend soạn sẵn.
  final String? reason;

  bool get isVerified => status == StudentStatus.verified;
}
