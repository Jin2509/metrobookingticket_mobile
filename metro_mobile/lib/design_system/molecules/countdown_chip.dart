import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Đếm ngược `⏱ 09:42` (QR thanh toán 10 phút). Dưới 1 phút đổi màu đỏ.
class CountdownChip extends StatefulWidget {
  const CountdownChip({required this.duration, this.onExpired, super.key});

  final Duration duration;
  final VoidCallback? onExpired;

  @override
  State<CountdownChip> createState() => _CountdownChipState();
}

class _CountdownChipState extends State<CountdownChip> {
  late Duration _left = widget.duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final next = _left - const Duration(seconds: 1);
    setState(() => _left = next.isNegative ? Duration.zero : next);
    if (_left == Duration.zero) {
      _timer?.cancel();
      widget.onExpired?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _label {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(_left.inMinutes)}:${two(_left.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final urgent = _left < const Duration(minutes: 1);
    final fg = urgent ? m.destructive : context.colors.primary;
    return Semantics(
      liveRegion: true,
      label: context.l10n.timeLeft(_label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: fg.withValues(alpha: .12),
          borderRadius: MetroRadius.brPill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.timer, size: 14, color: fg),
            const SizedBox(width: 4),
            Text(
              _label,
              style: MetroTypography.label.copyWith(
                color: fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
