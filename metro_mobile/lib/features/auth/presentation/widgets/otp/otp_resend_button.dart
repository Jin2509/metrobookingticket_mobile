import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Gửi lại mã (sau 60s)`. Chỉ bấm được khi hết thời gian chờ.
class OtpResendButton extends StatefulWidget {
  const OtpResendButton({
    required this.onResend,
    this.cooldown = const Duration(seconds: 60),
    super.key,
  });

  /// Trả `true` khi gửi thành công để bắt đầu chờ lại.
  final Future<bool> Function() onResend;
  final Duration cooldown;

  @override
  State<OtpResendButton> createState() => _OtpResendButtonState();
}

class _OtpResendButtonState extends State<OtpResendButton> {
  int _left = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _left = widget.cooldown.inSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _left--);
      if (_left <= 0) t.cancel();
    });
  }

  Future<void> _resend() async {
    if (await widget.onResend() && mounted) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final waiting = _left > 0;
    return TextButton(
      onPressed: waiting ? null : _resend,
      child: Text(
        waiting ? context.l10n.resendCodeIn(_left) : context.l10n.resendCode,
      ),
    );
  }
}
