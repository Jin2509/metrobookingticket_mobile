import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/mascot_painter.dart';

export 'package:metro_mobile/design_system/organisms/mascot/mascot_painter.dart'
    show MascotMood;

/// Linh vật Luke: đầu tàu có mặt, chớp mắt định kỳ và nảy lên khi chạm.
/// Không có hoạt ảnh lặp vô hạn để tiết kiệm pin.
class MetroMascot extends StatefulWidget {
  const MetroMascot({
    this.size = 72,
    this.onTap,
    this.semanticLabel,
    this.mood = MascotMood.normal,
    this.celebrate = false,
    super.key,
  });

  final MascotMood mood;

  /// Nảy lên một lần khi xuất hiện hoặc khi chuyển sang `true`.
  final bool celebrate;
  final double size;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<MetroMascot> createState() => _MetroMascotState();
}

class _MetroMascotState extends State<MetroMascot>
    with SingleTickerProviderStateMixin {
  late final _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );
  Timer? _blinkTimer;
  bool _blink = false;

  @override
  void initState() {
    super.initState();
    if (widget.celebrate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _bounceOnce();
      });
    }
    _blinkTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (!mounted) return;
      setState(() => _blink = true);
      await Future<void>.delayed(const Duration(milliseconds: 140));
      if (mounted) setState(() => _blink = false);
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _bounce.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MetroMascot old) {
    super.didUpdateWidget(old);
    if (widget.celebrate && !old.celebrate) _bounceOnce();
  }

  void _bounceOnce() {
    if (!MediaQuery.disableAnimationsOf(context)) {
      _bounce.forward(from: 0);
    }
  }

  void _tap() {
    _bounceOnce();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _tap,
        child: AnimatedBuilder(
          animation: _bounce,
          builder: (_, child) => Transform.translate(
            offset: Offset(
              0,
              -math.sin(_bounce.value * math.pi) * widget.size * .16,
            ),
            child: child,
          ),
          // Chớp mắt không làm vẽ lại danh sách đang cuộn phía sau.
          child: RepaintBoundary(
            child: CustomPaint(
              size: Size.square(widget.size),
              painter: MascotPainter(blink: _blink, mood: widget.mood),
            ),
          ),
        ),
      ),
    );
  }
}
