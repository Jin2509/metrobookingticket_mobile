import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';

@immutable
class AuthFormState {
  const AuthFormState({
    this.submitting = false,
    this.error,
    this.locked = false,
  });

  final bool submitting;
  final String? error;

  /// 403 tài khoản bị khóa: hiện banner thay vì lỗi dưới form.
  final bool locked;
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
    } on Failure catch (f) {
      if (ref.mounted) state = AuthFormState(error: f.message);
    }
    return null;
  }

  void clearError() => state = const AuthFormState();
}
