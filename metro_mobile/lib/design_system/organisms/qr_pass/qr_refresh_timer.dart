import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Làm mới sau 00:28` cho QR xoay vòng (Q3). Hết chu kỳ thì gọi
/// [onRefresh] và đếm lại.
class QrRefreshTimer extends StatefulWidget {
  const QrRefreshTimer({
    required this.onRefresh,
    this.period = const Duration(seconds: 30),
    super.key,
  });

  final VoidCallback onRefresh;
  final Duration period;

  @override
  State<QrRefreshTimer> createState() => _QrRefreshTimerState();
}

class _QrRefreshTimerState extends State<QrRefreshTimer> {
  late int _left = widget.period.inSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _left--);
      if (_left <= 0) {
        widget.onRefresh();
        setState(() => _left = widget.period.inSeconds);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ss = _left.toString().padLeft(2, '0');
    return Text(
      context.l10n.refreshIn('00:$ss'),
      style: context.text.bodySmall,
    );
  }
}
