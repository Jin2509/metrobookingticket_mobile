import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/metro_mascot.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/colors.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Màn mở app 2 giây: Futu bật lên thật to giữa nền thương hiệu, rồi hiện tên
/// app và slogan. Chỉ chạy một lần mỗi lần mở app, không chặn thao tác bên dưới
/// và bỏ qua khi người dùng tắt chuyển động.
class MascotOpening extends StatefulWidget {
  const MascotOpening({
    required this.title,
    required this.slogan,
    required this.child,
    super.key,
  });

  final String title;
  final String slogan;
  final Widget child;

  @override
  State<MascotOpening> createState() => _MascotOpeningState();
}

class _MascotOpeningState extends State<MascotOpening>
    with SingleTickerProviderStateMixin {
  late final _run = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  bool _started = false;
  bool _done = false;

  Animation<double> _interval(double from, double to, [Curve? curve]) =>
      CurvedAnimation(
        parent: _run,
        curve: Interval(from, to, curve: curve ?? Curves.easeOut),
      );

  late final _mascot = _interval(0, .5, Curves.elasticOut);
  late final _title = _interval(.32, .55);
  late final _slogan = _interval(.42, .65);
  late final _exit = _interval(.88, 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _done = true;
      return;
    }
    unawaited(
      _run.forward().whenComplete(() {
        if (mounted) setState(() => _done = true);
      }),
    );
  }

  @override
  void dispose() {
    _run.dispose();
    super.dispose();
  }

  Widget _rise(Animation<double> a, Widget child) => FadeTransition(
    opacity: a,
    child: SlideTransition(
      position: Tween(begin: const Offset(0, .4), end: Offset.zero).animate(a),
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (!_done)
          IgnorePointer(
            child: FadeTransition(
              opacity: ReverseAnimation(_exit),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [m.sidebar, const Color(0xFF0A4A55)],
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _mascot,
                        child: const MetroMascot(
                          size: 180,
                          mood: MascotMood.happy,
                        ),
                      ),
                      MetroSpacing.gapMd,
                      _rise(
                        _title,
                        Text(
                          widget.title,
                          style: context.text.headlineMedium?.copyWith(
                            color: MetroColors.primaryForeground,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      MetroSpacing.gapXxs,
                      _rise(
                        _slogan,
                        Padding(
                          padding: MetroSpacing.screenPadding,
                          child: Text(
                            widget.slogan,
                            textAlign: TextAlign.center,
                            style: context.text.bodyMedium?.copyWith(
                              color: m.sidebarForeground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
