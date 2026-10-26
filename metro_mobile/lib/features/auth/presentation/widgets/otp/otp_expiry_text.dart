import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Hết hạn sau 04:59`. Đổi `key` để chạy lại sau khi gửi lại mã.
class OtpExpiryText extends StatefulWidget {
  const OtpExpiryText({this.ttl = const Duration(minutes: 5), super.key});

  final Duration ttl;

  @override
  State<OtpExpiryText> createState() => _OtpExpiryTextState();
}

class _OtpExpiryTextState extends State<OtpExpiryText> {
  late int _left = widget.ttl.inSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _left--);
      if (_left <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    if (_left <= 0) {
      return Text(
        context.l10n.otpExpired,
        style: context.text.bodySmall?.copyWith(color: m.destructive),
      );
    }
    final mm = (_left ~/ 60).toString().padLeft(2, '0');
    final ss = (_left % 60).toString().padLeft(2, '0');
    return Text(
      context.l10n.expiresIn('$mm:$ss'),
      style: context.text.bodySmall,
    );
  }
}
