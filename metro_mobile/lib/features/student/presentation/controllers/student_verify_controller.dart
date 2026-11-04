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
    this.consent = false,
    this.submitting = false,
    this.retaking = false,
    this.result,
    this.error,
    this.pickFailed = false,
  });

  final Uint8List? image;
  final bool consent;
  final bool submitting;

  /// Người dùng muốn gửi lại dù đã có kết quả trước đó.
  final bool retaking;
  final StudentVerification? result;
  final String? error;
  final bool pickFailed;
}

final studentVerifyProvider =
    NotifierProvider.autoDispose<StudentVerifyController, StudentVerifyState>(
      StudentVerifyController.new,
    );

class StudentVerifyController extends Notifier<StudentVerifyState> {
  @override
  StudentVerifyState build() => const StudentVerifyState();

  Future<void> pick(ImageSource source) async {
    final consent = state.consent;
    try {
      final image = await ref.read(studentCardPickerProvider)(source);
      if (!ref.mounted || image == null) return;
      state = StudentVerifyState(
        image: image,
        consent: consent,
        retaking: true,
      );
    } on PlatformException {
      if (!ref.mounted) return;
      state = StudentVerifyState(
        image: state.image,
        consent: consent,
        retaking: true,
        pickFailed: true,
      );
    }
  }

  void setConsent({required bool value}) => state = StudentVerifyState(
    image: state.image,
    consent: value,
    retaking: state.retaking,
  );

  void retake() => state = const StudentVerifyState(retaking: true);

  Future<void> submit() async {
    final image = state.image;
    if (image == null || !state.consent || state.submitting) return;
    state = StudentVerifyState(
      image: image,
      consent: true,
      retaking: true,
      submitting: true,
    );
    try {
      final result = await ref
          .read(studentRepositoryProvider)
          .submitCard(image);
      if (!ref.mounted) return;
      // Không giữ ảnh thẻ trong bộ nhớ sau khi đã có kết quả.
      state = StudentVerifyState(result: result);
      ref.invalidate(studentVerificationProvider);
    } on Failure catch (f) {
      if (!ref.mounted) return;
      state = StudentVerifyState(
        image: image,
        consent: true,
        retaking: true,
        error: f.message,
      );
    }
  }
}
