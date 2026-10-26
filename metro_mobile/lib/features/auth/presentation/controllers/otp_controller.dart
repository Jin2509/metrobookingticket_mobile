import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final otpControllerProvider =
    NotifierProvider.autoDispose<OtpController, AuthFormState>(
      OtpController.new,
    );

class OtpController extends AuthFormController {
  Future<OtpVerification?> verify({
    required OtpPurpose purpose,
    required String email,
    required String code,
  }) async {
    final result = await run(
      () => ref
          .read(verifyOtpProvider)
          .call(purpose: purpose, email: email, code: code),
    );
    if (result is OtpSignedIn) {
      ref.read(authControllerProvider.notifier).signedIn(result.user);
    }
    return result;
  }

  Future<bool> resend({
    required OtpPurpose purpose,
    required String email,
  }) async {
    final ok = await run(() async {
      await ref.read(resendOtpProvider).call(purpose: purpose, email: email);
      return true;
    });
    return ok ?? false;
  }
}
