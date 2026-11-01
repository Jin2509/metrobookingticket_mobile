import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/profile/presentation/controllers/profile_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Họ tên và email. Chỉ hỏi mật khẩu khi email thay đổi; đổi email thì sang màn
/// nhập OTP gửi tới email mới.
class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({required this.profilePath, super.key});

  final String profilePath;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  late final SessionUser _initial = ref.read(authControllerProvider).value!;
  late final _name = TextEditingController(text: _initial.name);
  late final _email = TextEditingController(text: _initial.email);
  final _password = TextEditingController();

  bool get _changesEmail =>
      _email.text.trim().toLowerCase() != _initial.email.toLowerCase();

  @override
  void dispose() {
    for (final c in [_name, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final newEmail = _email.text.trim();
    final changesEmail = _changesEmail;
    final ok = await ref
        .read(profileControllerProvider.notifier)
        .save(
          user: _initial,
          name: _name.text,
          email: newEmail,
          currentPassword: _password.text,
        );
    if (!ok || !mounted) return;
    if (!changesEmail) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.profileSaved)));
      return;
    }
    await context.push(Routes.verifyNewEmail(widget.profilePath, newEmail));
    // Quay lại mà chưa xác nhận: email hiện tại vẫn là email cũ.
    if (!mounted) return;
    _password.clear();
    setState(() => _email.text = _initial.email);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetroTextField(
          label: context.l10n.fullName,
          controller: _name,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
        ),
        MetroSpacing.gapMd,
        MetroTextField(
          label: 'Email',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          onChanged: (_) => setState(() {}),
        ),
        if (_changesEmail) ...[
          MetroSpacing.gapMd,
          PasswordField(
            label: context.l10n.currentPassword,
            controller: _password,
          ),
        ],
        MetroSpacing.gapLg,
        MetroButton(
          label: context.l10n.saveProfile,
          expand: true,
          loading: state.submitting,
          onPressed: _save,
        ),
        AuthErrorText(state.error),
      ],
    );
  }
}
