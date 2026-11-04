import 'dart:typed_data';

import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/domain/repositories/student_repository.dart';

/// Giả lập backend đọc thẻ: không đọc ảnh thật, trả kết quả theo
/// `DemoLedger.studentDemoOutcome` để xem đủ các trạng thái trên giao diện.
class StudentFakeSource implements StudentRepository {
  StudentFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 1500),
  });

  final DemoLedger _ledger;
  final Duration latency;

  @override
  Future<StudentVerification> getMine() async {
    final record = _ledger.studentRecord;
    return record == null
        ? StudentVerification.none
        : StudentVerification.fromJson(record);
  }

  @override
  Future<StudentVerification> submitCard(Uint8List image) async {
    await Future<void>.delayed(latency);
    final outcome = _ledger.studentDemoOutcome;
    final card = <String, Object?>{
      'fullName': 'Nguyễn Minh Anh',
      'school': 'Đại học Quốc gia TP.HCM',
      'studentCode': '22520001',
      'validUntil': _ledger
          .clock()
          .add(const Duration(days: 300))
          .toIso8601String(),
    };
    final record = <String, Object?>{
      'status': outcome,
      ...switch (outcome) {
        'VERIFIED' => card,
        'PENDING' => {
          ...card,
          'reason':
              'Họ tên trên thẻ chưa khớp tài khoản, nhân viên sẽ kiểm tra '
              'trong 24 giờ.',
        },
        _ => {
          'reason':
              'Ảnh mờ nên chưa đọc được hạn thẻ. Chụp lại nơi đủ sáng nha.',
        },
      },
    };
    _ledger.studentRecord = record;
    return StudentVerification.fromJson(record);
  }
}
