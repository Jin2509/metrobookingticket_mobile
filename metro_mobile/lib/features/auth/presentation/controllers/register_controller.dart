import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final registerControllerProvider =
    NotifierProvider.autoDispose<RegisterController, AuthFormState>(
      RegisterController.new,
    );

class RegisterController extends AuthFormController {
  /// Có kết quả thì mở màn OTP, kể cả khi email đang chờ xác thực.
  Future<RegisterResult?> submit({
    required String name,
    required String email,
    required String password,
    required String confirm,
    required bool acceptedTerms,
  }) => run(
    () => ref
        .read(registerProvider)
        .call(
          name: name,
          email: email,
          password: password,
          confirm: confirm,
          acceptedTerms: acceptedTerms,
        ),
  );
}
