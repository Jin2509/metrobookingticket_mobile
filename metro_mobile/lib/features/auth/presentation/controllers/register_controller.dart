import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final registerControllerProvider =
    NotifierProvider.autoDispose<RegisterController, AuthFormState>(
      RegisterController.new,
    );

class RegisterController extends AuthFormController {
  /// `true` khi đã tạo tài khoản và gửi OTP.
  Future<bool> submit({
    required String name,
    required String email,
    required String password,
    required String confirm,
    required bool acceptedTerms,
  }) async {
    final ok = await run(() async {
      await ref
          .read(registerProvider)
          .call(
            name: name,
            email: email,
            password: password,
            confirm: confirm,
            acceptedTerms: acceptedTerms,
          );
      return true;
    });
    return ok ?? false;
  }
}
