import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_fake_source.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_remote_source.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:metro_mobile/features/auth/domain/usecases/forgot_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/login.dart';
import 'package:metro_mobile/features/auth/domain/usecases/logout.dart';
import 'package:metro_mobile/features/auth/domain/usecases/register.dart';
import 'package:metro_mobile/features/auth/domain/usecases/resend_otp.dart';
import 'package:metro_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:metro_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:metro_mobile/features/auth/domain/usecases/verify_otp.dart';

/// BASE_URL rỗng → Fake source (demo offline).
final authSourceProvider = Provider<AuthSource>(
  (ref) => Env.useFakeData
      ? AuthFakeSource()
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
final registerProvider = Provider(
  (ref) => Register(ref.watch(authRepositoryProvider)),
);
final verifyOtpProvider = Provider(
  (ref) => VerifyOtp(ref.watch(authRepositoryProvider)),
);
final resendOtpProvider = Provider(
  (ref) => ResendOtp(ref.watch(authRepositoryProvider)),
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
