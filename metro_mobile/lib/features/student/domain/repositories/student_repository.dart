import 'dart:typed_data';

import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';

abstract interface class StudentRepository {
  Future<StudentVerification> getMine();

  /// Gửi ảnh thẻ cho backend kiểm tra.
  Future<StudentVerification> submitCard(Uint8List image);
}
