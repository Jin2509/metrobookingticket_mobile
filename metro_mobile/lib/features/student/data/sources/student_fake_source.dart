import 'dart:async';
import 'dart:typed_data';

import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/domain/repositories/student_repository.dart';

/// Giả lập backend duyệt thẻ: không đọc ảnh thật. Gửi xong là chờ duyệt, sau
/// [reviewDelay] có kết quả theo `DemoLedger.studentDemoOutcome` và đẩy thông
/// báo. Bản thật có thể mất tới 24 giờ.
class StudentFakeSource implements StudentRepository {
  StudentFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 800),
    this.reviewDelay = const Duration(seconds: 6),
  });

  final DemoLedger _ledger;
  final Duration latency;
  final Duration reviewDelay;

  static const _link = '/p/student/verify';

  @override
  Future<StudentVerification> getMine() async {
    final record = _ledger.studentRecord;
    if (record == null) return StudentVerification.none;
    final current = StudentVerification.fromJson(record);
    if (current.status == StudentStatus.verified &&
        !current.isActive(_ledger.clock())) {
      record['status'] = 'EXPIRED';
      return StudentVerification.fromJson(record);
    }
    return current;
  }

  @override
  Future<StudentVerification> submitCard(Uint8List image) async {
    await Future<void>.delayed(latency);
    final record = <String, Object?>{
      'status': 'PENDING',
      'submittedAt': _ledger.clock().toIso8601String(),
      // Đang gia hạn thì ưu đãi cũ vẫn dùng được tới hết hạn.
      'expiresAt': _ledger.studentRecord?['expiresAt'],
    };
    _ledger.studentRecord = record;
    final result = StudentVerification.fromJson(record);
    if (reviewDelay == Duration.zero) {
      _finishReview();
    } else {
      Timer(reviewDelay, _finishReview);
    }
    return result;
  }

  void _finishReview() {
    final now = _ledger.clock();
    final outcome = _ledger.studentDemoOutcome;
    final card = <String, Object?>{
      'fullName': 'Nguyễn Minh Anh',
      'school': 'Đại học Quốc gia TP.HCM',
      'studentCode': '22520001',
    };
    String until(int days) => now.add(Duration(days: days)).toIso8601String();
    _ledger.studentRecord = switch (outcome) {
      'VERIFIED' => {...card, 'status': 'VERIFIED', 'expiresAt': until(365)},
      'EXPIRING' => {...card, 'status': 'VERIFIED', 'expiresAt': until(20)},
      'EXPIRED' => {
        ...card,
        'status': 'EXPIRED',
        'expiresAt': until(-1),
        'reason': 'Xác nhận đã hết hiệu lực sau 1 năm.',
      },
      _ => {
        'status': 'REJECTED',
        'expiresAt': _ledger.studentRecord?['expiresAt'],
        'reason': 'Ảnh mờ nên chưa đọc được hạn thẻ. Chụp lại nơi đủ sáng nha.',
      },
    };
    final passed = outcome == 'VERIFIED' || outcome == 'EXPIRING';
    _ledger.notify(
      'PROMOTION',
      passed ? 'Đã xác nhận sinh viên' : 'Chưa xác nhận được sinh viên',
      body: passed
          ? 'Ưu đãi sinh viên đã sẵn sàng khi bạn đặt vé.'
          : 'Mở để xem lý do và gửi lại thẻ.',
      link: _link,
    );
  }
}
