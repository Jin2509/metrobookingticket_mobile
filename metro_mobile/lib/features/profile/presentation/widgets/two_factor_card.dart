import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/profile/presentation/controllers/profile_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Bật/tắt xác nhận 2 lớp. Các phiên đang đăng nhập không bị ảnh hưởng.
class TwoFactorCard extends ConsumerWidget {
  const TwoFactorCard({super.key});

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final done = enabled
        ? context.l10n.twoFactorEnabledDone
        : context.l10n.twoFactorDisabledDone;
    final password = await showDialog<String>(
      context: context,
      builder: (_) => const _ConfirmPasswordDialog(),
    );
    if (password == null) return;
    final ok = await ref
        .read(twoFactorSettingControllerProvider.notifier)
        .submit(enabled: enabled, currentPassword: password);
    if (ok) messenger.showSnackBar(SnackBar(content: Text(done)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(twoFactorSettingControllerProvider);
    final enabled =
        ref.watch(authControllerProvider).value?.twoFactorEnabled ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.l10n.twoFactorTitle,
            style: context.text.titleMedium,
          ),
          subtitle: Text(
            context.l10n.twoFactorHint,
            style: context.text.bodySmall,
          ),
          value: enabled,
          onChanged: state.submitting ? null : (v) => _toggle(context, ref, v),
        ),
        AuthErrorText(state.error),
      ],
    );
  }
}

/// Trả về mật khẩu đã nhập, `null` nếu hủy.
class _ConfirmPasswordDialog extends StatefulWidget {
  const _ConfirmPasswordDialog();

  @override
  State<_ConfirmPasswordDialog> createState() => _ConfirmPasswordDialogState();
}

class _ConfirmPasswordDialogState extends State<_ConfirmPasswordDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.twoFactorTitle),
      content: PasswordField(
        label: context.l10n.currentPassword,
        controller: _password,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _password.text),
          child: Text(context.l10n.confirm),
        ),
      ],
    );
  }
}
