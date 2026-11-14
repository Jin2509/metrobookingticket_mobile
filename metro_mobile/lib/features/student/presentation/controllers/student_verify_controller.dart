import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/student_providers.dart';

@immutable
class StudentVerifyState {
  const StudentVerifyState({
    this.image,
    this.declaration = const StudentDeclaration(),
    this.consent = false,
    this.submitting = false,
    this.renewing = false,
    this.error,
    this.pickFailed = false,
  });

  final Uint8List? image;

  /// Họ tên, mã sinh viên, trường như in trên thẻ.
  final StudentDeclaration declaration;
  final bool consent;
  final bool submitting;

  /// Đang còn hiệu lực nhưng người dùng chủ động xác nhận lại.
  final bool renewing;
  final String? error;
  final bool pickFailed;

  bool get canSubmit =>
      image != null && consent && declaration.isComplete && !submitting;

  /// Lỗi và cờ chọn ảnh lỗi chỉ hiện tới lần thao tác kế tiếp.
  StudentVerifyState next({
    Uint8List? image,
    StudentDeclaration? declaration,
    bool? consent,
    bool submitting = false,
    String? error,
    bool pickFailed = false,
  }) => StudentVerifyState(
    image: image ?? this.image,
    declaration: declaration ?? this.declaration,
    consent: consent ?? this.consent,
    submitting: submitting,
    renewing: renewing,
    error: error,
    pickFailed: pickFailed,
  );
}

final studentVerifyProvider =
    NotifierProvider.autoDispose<StudentVerifyController, StudentVerifyState>(
      StudentVerifyController.new,
    );

class StudentVerifyController extends Notifier<StudentVerifyState> {
  @override
  StudentVerifyState build() => const StudentVerifyState();

  Future<void> pick(ImageSource source) async {
    try {
      final image = await ref.read(studentCardPickerProvider)(source);
      if (!ref.mounted || image == null) return;
      state = state.next(image: image);
    } on PlatformException {
      if (!ref.mounted) return;
      state = state.next(pickFailed: true);
    }
  }

  void setConsent({required bool value}) =>
      state = state.next(consent: value);

  void setDeclaration(StudentDeclaration d) =>
      state = state.next(declaration: d);

  void renew() => state = const StudentVerifyState(renewing: true);

  Future<void> submit() async {
    final s = state;
    final image = s.image;
    if (image == null || !s.canSubmit) return;
    state = s.next(submitting: true);
    try {
      await ref
          .read(studentRepositoryProvider)
          .submitCard(image, s.declaration);
      ref.invalidate(studentVerificationProvider);
      await ref.read(studentVerificationProvider.future);
      // Không giữ ảnh thẻ trong bộ nhớ sau khi đã gửi.
      if (ref.mounted) state = const StudentVerifyState();
    } on Failure catch (f) {
      if (!ref.mounted) return;
      state = s.next(error: f.message);
    }
  }
}
