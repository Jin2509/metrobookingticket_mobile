import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Gửi lại mã (sau 60s)`. Chỉ bấm được khi hết thời gian chờ.
class OtpResendButton extends StatefulWidget {
  const OtpResendButton({required this.onResend, super.key});

  /// Backend chặn 60s giữa hai lần gửi.
  static const cooldown = Duration(seconds: 60);

  /// Trả thời gian chờ tiếp theo: [cooldown] khi gửi được, `Retry-After` khi
  /// bị 429, `null` khi lỗi khác (cho bấm lại ngay).
  final Future<Duration?> Function() onResend;

  @override
  State<OtpResendButton> createState() => _OtpResendButtonState();
}

class _OtpResendButtonState extends State<OtpResendButton> {
  int _left = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start(OtpResendButton.cooldown);
  }

  void _start(Duration wait) {
    _timer?.cancel();
    setState(() => _left = wait.inSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _left--);
      if (_left <= 0) t.cancel();
    });
  }

  Future<void> _resend() async {
    final wait = await widget.onResend();
    if (wait != null && mounted) _start(wait);
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
