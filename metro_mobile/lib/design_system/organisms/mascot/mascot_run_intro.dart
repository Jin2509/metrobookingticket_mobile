import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/mascot_run_track.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/colors.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Intro 2 giây sau khi đăng nhập: Futu chạy dọc đường ray qua màn hình rồi tự
/// ẩn. Không chặn thao tác, kể cả khi màn phía sau đang chuyển.
abstract final class MascotRunIntro {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_current?.mounted ?? false) _current!.remove();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _IntroView(
        title: title,
        message: message,
        onDone: () {
          if (identical(_current, entry)) {
            if (entry.mounted) entry.remove();
            _current = null;
          }
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }
}

class _IntroView extends StatefulWidget {
  const _IntroView({
    required this.title,
    required this.message,
    required this.onDone,
  });

  final String title;
  final String message;
  final VoidCallback onDone;

  @override
  State<_IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<_IntroView>
    with SingleTickerProviderStateMixin {
  late final _run = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  late final _backdrop = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 10),
    TweenSequenceItem(tween: ConstantTween(1), weight: 78),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 12),
  ]).animate(_run);

  late final _text = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0), weight: 15),
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 15),
    TweenSequenceItem(tween: ConstantTween(1), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 12),
    TweenSequenceItem(tween: ConstantTween(0), weight: 8),
  ]).animate(_run);

  @override
  void initState() {
    super.initState();
    unawaited(
      _run.forward().whenComplete(() {
        if (mounted) widget.onDone();
      }),
    );
  }

  @override
  void dispose() {
    _run.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return IgnorePointer(
      child: FadeTransition(
        opacity: _backdrop,
        child: ColoredBox(
          color: m.sidebar,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MascotRunTrack(progress: _run),
                MetroSpacing.gapLg,
                FadeTransition(
                  opacity: _text,
                  child: Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: MetroSpacing.screenPadding,
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: context.text.titleLarge?.copyWith(
                              color: MetroColors.primaryForeground,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          MetroSpacing.gapXxs,
                          Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: context.text.bodyMedium?.copyWith(
                              color: m.sidebarForeground,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
