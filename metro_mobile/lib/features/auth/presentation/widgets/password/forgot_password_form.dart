import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/password_controllers.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhập email để nhận OTP đặt lại mật khẩu (404 nếu email chưa đăng ký).
class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends ConsumerState<ForgotPasswordForm> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final ok = await ref
        .read(forgotPasswordControllerProvider.notifier)
        .submit(email);
    if (!ok || !mounted) return;
    await context.push(Routes.otpFor(OtpPurpose.reset, email));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetroTextField(
          label: context.l10n.registeredEmail,
          prefixIcon: LucideIcons.mail,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        MetroSpacing.gapLg,
        MetroButton(
          label: context.l10n.sendCode,
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
