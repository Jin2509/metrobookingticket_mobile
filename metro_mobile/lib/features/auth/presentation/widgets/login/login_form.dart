import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/login_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/locked_banner.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/login/login_options_row.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Form A1. Không có lựa chọn vai trò: vai trò lấy từ phản hồi đăng nhập.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({this.from, super.key});

  /// Đường dẫn cần quay lại sau khi đăng nhập (deep link).
  final String? from;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _id = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(loginControllerProvider.notifier)
        .submit(
          identifier: _id.text,
          password: _password.text,
          remember: _remember,
        );
    if (!mounted || result is! LoginNeedsOtp) return;
    await context.push(
      Routes.otpFor(OtpPurpose.login2fa, result.email, from: widget.from),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.locked) LockedBanner(message: state.error!),
          MetroTextField(
            label: context.l10n.emailOrPhone,
            hint: 'ten@email.com',
            prefixIcon: LucideIcons.user,
            controller: _id,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
          ),
          MetroSpacing.gapMd,
          PasswordField(
            controller: _password,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          MetroSpacing.gapXs,
          LoginOptionsRow(
            remember: _remember,
            onRememberChanged: (v) => setState(() => _remember = v),
          ),
          MetroSpacing.gapSm,
          MetroButton(
            label: context.l10n.login,
            size: MetroButtonSize.lg,
            expand: true,
            loading: state.submitting,
            onPressed: _submit,
          ),
          if (!state.locked) AuthErrorText(state.error),
        ],
      ),
    );
  }
}
