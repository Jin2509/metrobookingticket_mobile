import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_fake_source.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_remote_source.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:metro_mobile/features/auth/domain/usecases/change_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/forgot_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/login.dart';
import 'package:metro_mobile/features/auth/domain/usecases/logout.dart';
import 'package:metro_mobile/features/auth/domain/usecases/register.dart';
import 'package:metro_mobile/features/auth/domain/usecases/resend_code.dart';
import 'package:metro_mobile/features/auth/domain/usecases/resend_login_code.dart';
import 'package:metro_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:metro_mobile/features/auth/domain/usecases/set_two_factor.dart';
import 'package:metro_mobile/features/auth/domain/usecases/update_profile.dart';
import 'package:metro_mobile/features/auth/domain/usecases/verify_email.dart';
import 'package:metro_mobile/features/auth/domain/usecases/verify_login_code.dart';
import 'package:metro_mobile/features/auth/domain/usecases/verify_new_email.dart';

/// BASE_URL rỗng → Fake source (demo offline).
final authSourceProvider = Provider<AuthSource>(
  (ref) => Env.useFakeAuth
      ? AuthFakeSource(ref.watch(secureStoreProvider))
      : AuthRemoteSource(ref.watch(dioProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authSourceProvider),
    ref.watch(secureStoreProvider),
  ),
);

final loginProvider = Provider(
  (ref) => Login(ref.watch(authRepositoryProvider)),
);
final verifyLoginCodeProvider = Provider(
  (ref) => VerifyLoginCode(ref.watch(authRepositoryProvider)),
);
final resendLoginCodeProvider = Provider(
  (ref) => ResendLoginCode(ref.watch(authRepositoryProvider)),
);
final setTwoFactorProvider = Provider(
  (ref) => SetTwoFactor(ref.watch(authRepositoryProvider)),
);
final registerProvider = Provider(
  (ref) => Register(ref.watch(authRepositoryProvider)),
);
final verifyEmailProvider = Provider(
  (ref) => VerifyEmail(ref.watch(authRepositoryProvider)),
);
final resendCodeProvider = Provider(
  (ref) => ResendCode(ref.watch(authRepositoryProvider)),
);
final forgotPasswordProvider = Provider(
  (ref) => ForgotPassword(ref.watch(authRepositoryProvider)),
);
final resetPasswordProvider = Provider(
  (ref) => ResetPassword(ref.watch(authRepositoryProvider)),
);
final logoutProvider = Provider(
  (ref) => Logout(ref.watch(authRepositoryProvider)),
);
final restoreSessionProvider = Provider(
  (ref) => RestoreSession(ref.watch(authRepositoryProvider)),
);
final updateProfileProvider = Provider(
  (ref) => UpdateProfile(ref.watch(authRepositoryProvider)),
);
final verifyNewEmailProvider = Provider(
  (ref) => VerifyNewEmail(ref.watch(authRepositoryProvider)),
);
final changePasswordProvider = Provider(
  (ref) => ChangePassword(ref.watch(authRepositoryProvider)),
);
