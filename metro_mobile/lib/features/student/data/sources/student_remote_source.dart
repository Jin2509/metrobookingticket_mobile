import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/domain/repositories/student_repository.dart';

typedef _Json = Map<String, Object?>;

/// Backend chưa có các endpoint này, đây là hợp đồng đề xuất. Việc gọi AI đọc
/// thẻ nằm ở backend: app không giữ khóa API và không tự quyết định ưu đãi.
class StudentRemoteSource implements StudentRepository {
  const StudentRemoteSource(this._dio);
  final Dio _dio;

  static const _path = '/api/student-verifications';

  @override
  Future<StudentVerification> getMine() async {
    try {
      final res = await _dio.get<_Json>('$_path/me');
      return StudentVerification.fromJson(res.data!);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NotFoundFailure) return StudentVerification.none;
      throw failure;
    }
  }

  @override
  Future<StudentVerification> submitCard(Uint8List image) async {
    try {
      final res = await _dio.post<_Json>(
        _path,
        data: FormData.fromMap({
          'consent': true,
          'image': MultipartFile.fromBytes(
            image,
            filename: 'student-card.jpg',
            contentType: DioMediaType('image', 'jpeg'),
          ),
        }),
      );
      return StudentVerification.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
