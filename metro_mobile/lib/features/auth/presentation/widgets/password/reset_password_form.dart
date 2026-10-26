import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/password_controllers.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Đặt mật khẩu mới, xong quay về đăng nhập.
class ResetPasswordForm extends ConsumerStatefulWidget {
  const ResetPasswordForm({required this.resetToken, super.key});

  final String resetToken;

  @override
  ConsumerState<ResetPasswordForm> createState() => _ResetFormState();
}

class _ResetFormState extends ConsumerState<ResetPasswordForm> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(resetPasswordControllerProvider.notifier)
        .submit(
          resetToken: widget.resetToken,
          password: _password.text,
          confirm: _confirm.text,
        );
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.resetPasswordDone)));
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PasswordField(
          label: context.l10n.newPassword,
          controller: _password,
          showStrength: true,
        ),
        MetroSpacing.gapMd,
        PasswordField(
          label: context.l10n.confirmNewPassword,
          controller: _confirm,
        ),
        MetroSpacing.gapLg,
        MetroButton(
          label: context.l10n.saveNewPassword,
          size: MetroButtonSize.lg,
          expand: true,
          loading: state.submitting,
          onPressed: _submit,
        ),
        AuthErrorText(state.error),
      ],
    );
  }
}
