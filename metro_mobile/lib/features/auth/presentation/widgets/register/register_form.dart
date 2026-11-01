import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/register_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/register/terms_checkbox.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Form A2. Thành công thì mở OTP xác thực email.
class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _terms = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(registerControllerProvider.notifier)
        .submit(
          name: _name.text,
          email: _email.text,
          password: _password.text,
          confirm: _confirm.text,
          acceptedTerms: _terms,
        );
    if (result == null || !mounted) return;
    if (result.alreadyPending) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.registerPendingCode)));
    }
    await context.push(
      Routes.otpFor(_email.text.trim(), expiresIn: result.codeExpiresIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
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
          hint: context.l10n.otpWillBeSent,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
        ),
        MetroSpacing.gapMd,
        PasswordField(controller: _password, showStrength: true),
        MetroSpacing.gapMd,
        PasswordField(
          label: context.l10n.confirmPassword,
          controller: _confirm,
        ),
        MetroSpacing.gapXs,
        TermsCheckbox(
          value: _terms,
          onChanged: (v) => setState(() => _terms = v),
        ),
        MetroSpacing.gapSm,
        MetroButton(
          label: context.l10n.continueLabel,
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
