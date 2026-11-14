import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/domain/repositories/student_repository.dart';

typedef _Json = Map<String, Object?>;

/// `GET /api/v1/me/student-status` và `POST /me/student-verifications`.
/// Việc gọi AI đọc thẻ nằm ở backend: app không giữ khóa API và không tự
/// quyết định ưu đãi.
class StudentRemoteSource implements StudentRepository {
  const StudentRemoteSource(this._dio);
  final Dio _dio;

  static const _base = '/api/v1/me';

  static DateTime? _at(Object? v) => v == null ? null : DateTime.parse('$v');

  /// `LocalDate` hạn ưu đãi → hết ngày đó (giờ Việt Nam).
  static DateTime? _until(Object? v) {
    if (v == null) return null;
    final d = DateTime.parse('$v');
    return DateTime.utc(
      d.year,
      d.month,
      d.day,
      23,
      59,
      59,
    ).subtract(const Duration(hours: 7));
  }

  /// `StudentStatusResponse` → trạng thái của app.
  static StudentVerification _fromStatus(_Json j) {
    final latest = j['latest'] as _Json?;
    final verified = j['verified'] == true;
    final expiresAt = _until(j['validUntil']);
    final status = switch (latest?['status']) {
      'PENDING' || 'PROCESSING' || 'NEEDS_REVIEW' => StudentStatus.pending,
      _ when verified => StudentStatus.verified,
      'REJECTED' || 'REVOKED' => StudentStatus.rejected,
      'APPROVED' => StudentStatus.expired,
      _ => StudentStatus.none,
    };
    if (latest == null) {
      return StudentVerification(status: status, expiresAt: expiresAt);
    }
    return StudentVerification(
      status: status,
      fullName: latest['declaredFullName'] as String?,
      school: latest['declaredSchool'] as String?,
      studentCode: latest['declaredStudentCode'] as String?,
      expiresAt: expiresAt ?? _until(latest['approvedUntil']),
      submittedAt: _at(latest['submittedAt']),
      reason:
          status == StudentStatus.rejected || status == StudentStatus.expired
          ? latest['message'] as String?
          : null,
    );
  }

  @override
  Future<StudentVerification> getMine() async {
    try {
      final res = await _dio.get<_Json>('$_base/student-status');
      return _fromStatus(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<StudentVerification> submitCard(
    Uint8List image,
    StudentDeclaration d,
  ) async {
    try {
      final res = await _dio.post<_Json>(
        '$_base/student-verifications',
        data: FormData.fromMap({
          'consent': true,
          'fullName': d.fullName.trim(),
          'studentCode': d.studentCode.trim(),
          'school': d.school.trim(),
          'image': MultipartFile.fromBytes(
            image,
            filename: 'student-card.jpg',
            contentType: DioMediaType('image', 'jpeg'),
          ),
        }),
      );
      final j = res.data!;
      return StudentVerification(
        status: StudentStatus.pending,
        fullName: j['declaredFullName'] as String?,
        school: j['declaredSchool'] as String?,
        studentCode: j['declaredStudentCode'] as String?,
        submittedAt: _at(j['submittedAt']),
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
