import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/demo_hint.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_expiry_text.dart';
import 'package:metro_mobile/features/profile/presentation/controllers/profile_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhập OTP gửi tới email mới. Backend không có API gửi lại riêng: muốn mã mới
/// thì quay lại gửi `PUT /api/me/profile` lần nữa.
class VerifyNewEmailScreen extends ConsumerStatefulWidget {
  const VerifyNewEmailScreen({required this.email, super.key});

  final String email;

  @override
  ConsumerState<VerifyNewEmailScreen> createState() => _VerifyState();
}

class _VerifyState extends ConsumerState<VerifyNewEmailScreen> {
  final _code = TextEditingController();

  VerifyNewEmailController get _ctrl =>
      ref.read(verifyNewEmailControllerProvider.notifier);

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final messenger = ScaffoldMessenger.of(context);
    final done = context.l10n.emailChangedRelogin;
    final ok = await _ctrl.verify(email: widget.email, code: _code.text);
    if (ok) messenger.showSnackBar(SnackBar(content: Text(done)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyNewEmailControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.verifyNewEmailTitle)),
      body: ListView(
        padding: const EdgeInsets.all(MetroSpacing.md),
        children: [
          Text.rich(
            TextSpan(
              text: context.l10n.otpSentTo,
              children: [
                TextSpan(
                  text: maskEmail(widget.email),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            style: context.text.bodyMedium,
          ),
          MetroSpacing.gapLg,
          OtpInput(
            controller: _code,
            autofocus: true,
            hasError: state.error != null,
            onChanged: (_) {
              if (state.error != null) _ctrl.clearError();
            },
            onCompleted: (_) => _verify(),
          ),
          AuthErrorText(state.error),
          MetroSpacing.gapMd,
          const OtpExpiryText(),
          MetroSpacing.gapXs,
          Text(context.l10n.verifyNewEmailHint, style: context.text.bodySmall),
          MetroSpacing.gapMd,
          MetroButton(
            label: context.l10n.confirm,
            size: MetroButtonSize.lg,
            expand: true,
            loading: state.submitting,
            onPressed: _verify,
          ),
          DemoHint(lines: [context.l10n.demoOtp(AuthDemo.otp)]),
        ],
      ),
    );
  }
}
