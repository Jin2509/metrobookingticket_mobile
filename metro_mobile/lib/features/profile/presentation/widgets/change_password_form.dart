import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/profile/presentation/controllers/profile_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Đổi mật khẩu. Xong mọi thiết bị phải đăng nhập lại.
class ChangePasswordForm extends ConsumerStatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  ConsumerState<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends ConsumerState<ChangePasswordForm> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_current, _next, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final done = context.l10n.passwordChangedRelogin;
    final ok = await ref
        .read(changePasswordControllerProvider.notifier)
        .submit(
          currentPassword: _current.text,
          newPassword: _next.text,
          confirm: _confirm.text,
        );
    if (ok) messenger.showSnackBar(SnackBar(content: Text(done)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.changePassword, style: context.text.titleMedium),
        MetroSpacing.gapXxs,
        Text(context.l10n.changePasswordHint, style: context.text.bodySmall),
        MetroSpacing.gapMd,
        PasswordField(
          label: context.l10n.currentPassword,
          controller: _current,
        ),
        MetroSpacing.gapMd,
        PasswordField(
          label: context.l10n.newPassword,
          controller: _next,
          showStrength: true,
        ),
        MetroSpacing.gapMd,
        PasswordField(
          label: context.l10n.confirmNewPassword,
          controller: _confirm,
        ),
        MetroSpacing.gapLg,
        MetroButton(
          label: context.l10n.changePassword,
          expand: true,
          loading: state.submitting,
          onPressed: _submit,
        ),
        AuthErrorText(state.error),
      ],
    );
  }
}
