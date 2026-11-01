import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';

@immutable
class AuthFormState {
  const AuthFormState({
    this.submitting = false,
    this.error,
    this.locked = false,
    this.unverified = false,
    this.retryAfter,
    this.twoFactor,
  });

  final bool submitting;
  final String? error;

  /// 403 tài khoản bị khóa: hiện banner thay vì lỗi dưới form.
  final bool locked;

  /// 403 email chưa xác thực: chuyển sang màn OTP.
  final bool unverified;

  /// 429 có `Retry-After`: thời gian phải chờ.
  final Duration? retryAfter;

  /// Đúng mật khẩu, còn phải nhập mã gửi qua email.
  final TwoFactorRequiredFailure? twoFactor;
}

/// Base cho các form auth: khóa nút khi gửi, đổi `Failure` thành thông điệp.
abstract class AuthFormController extends Notifier<AuthFormState> {
  @override
  AuthFormState build() => const AuthFormState();

  Future<T?> run<T>(Future<T> Function() action) async {
    if (state.submitting) return null;
    state = const AuthFormState(submitting: true);
    try {
      final result = await action();
      if (ref.mounted) state = const AuthFormState();
      return result;
    } on AccountLockedFailure catch (f) {
      if (ref.mounted) state = AuthFormState(error: f.message, locked: true);
    } on EmailNotVerifiedFailure catch (f) {
      if (ref.mounted) {
        state = AuthFormState(error: f.message, unverified: true);
      }
    } on TwoFactorRequiredFailure catch (f) {
      if (ref.mounted) state = AuthFormState(twoFactor: f);
    } on RateLimitedFailure catch (f) {
      if (ref.mounted) {
        state = AuthFormState(error: f.message, retryAfter: f.retryAfter);
      }
    } on Failure catch (f) {
      if (ref.mounted) state = AuthFormState(error: f.message);
    }
    return null;
  }

  /// `true` khi [action] xong không lỗi.
  Future<bool> runOk(Future<void> Function() action) async {
    final ok = await run(() async {
      await action();
      return true;
    });
    return ok ?? false;
  }

  void clearError() => state = const AuthFormState();
}
