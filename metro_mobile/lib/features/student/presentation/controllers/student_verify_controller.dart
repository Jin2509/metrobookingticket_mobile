import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/student/student_providers.dart';

@immutable
class StudentVerifyState {
  const StudentVerifyState({
    this.image,
    this.consent = false,
    this.submitting = false,
    this.renewing = false,
    this.error,
    this.pickFailed = false,
  });

  final Uint8List? image;
  final bool consent;
  final bool submitting;

  /// Đang còn hiệu lực nhưng người dùng chủ động xác nhận lại.
  final bool renewing;
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
    final s = state;
    try {
      final image = await ref.read(studentCardPickerProvider)(source);
      if (!ref.mounted || image == null) return;
      state = StudentVerifyState(
        image: image,
        consent: s.consent,
        renewing: s.renewing,
      );
    } on PlatformException {
      if (!ref.mounted) return;
      state = StudentVerifyState(
        image: s.image,
        consent: s.consent,
        renewing: s.renewing,
        pickFailed: true,
      );
    }
  }

  void setConsent({required bool value}) => state = StudentVerifyState(
    image: state.image,
    consent: value,
    renewing: state.renewing,
  );

  void renew() => state = const StudentVerifyState(renewing: true);

  Future<void> submit() async {
    final s = state;
    final image = s.image;
    if (image == null || !s.consent || s.submitting) return;
    state = StudentVerifyState(
      image: image,
      consent: true,
      renewing: s.renewing,
      submitting: true,
    );
    try {
      await ref.read(studentRepositoryProvider).submitCard(image);
      ref.invalidate(studentVerificationProvider);
      await ref.read(studentVerificationProvider.future);
      // Không giữ ảnh thẻ trong bộ nhớ sau khi đã gửi.
      if (ref.mounted) state = const StudentVerifyState();
    } on Failure catch (f) {
      if (!ref.mounted) return;
      state = StudentVerifyState(
        image: image,
        consent: true,
        renewing: s.renewing,
        error: f.message,
      );
    }
  }
}
