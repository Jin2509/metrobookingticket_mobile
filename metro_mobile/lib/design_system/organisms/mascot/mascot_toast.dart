import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/metro_mascot.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Futu báo kết quả thao tác ở đầu màn hình, thay cho SnackBar. Không chặn
/// thao tác bên dưới và tự ẩn. Lấy `of(context)` trước khi `await` nếu sau đó
/// màn hình có thể đã đóng.
class MascotToast {
  MascotToast._(this._overlay);

  factory MascotToast.of(BuildContext context) =>
      MascotToast._(Overlay.of(context, rootOverlay: true));

  final OverlayState _overlay;

  /// Thông báo đang hiện, chỉ giữ một cái tại một thời điểm.
  static OverlayEntry? _current;

  void call(String message, {MascotMood mood = MascotMood.happy}) {
    if (!_overlay.mounted) return;
    if (_current?.mounted ?? false) _current!.remove();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastView(
        message: message,
        mood: mood,
        onDone: () {
          if (identical(_current, entry)) {
            if (entry.mounted) entry.remove();
            _current = null;
          }
        },
      ),
    );
    _current = entry;
    _overlay.insert(entry);
  }
}

class _ToastView extends StatefulWidget {
  const _ToastView({
    required this.message,
    required this.mood,
    required this.onDone,
  });

  final String message;
  final MascotMood mood;
  final VoidCallback onDone;

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView>
    with SingleTickerProviderStateMixin {
  static const _visible = Duration(milliseconds: 3600);

  late final _show = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..forward();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_visible, () async {
      await _show.reverse();
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _show.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final tone = switch (widget.mood) {
      MascotMood.happy => m.success,
      MascotMood.worried => m.destructive,
      _ => context.colors.primary,
    };
    final curve = CurvedAnimation(parent: _show, curve: Curves.easeOutBack);
    return Positioned(
      top: MediaQuery.paddingOf(context).top + MetroSpacing.xs,
      left: MetroSpacing.md,
      right: MetroSpacing.md,
      child: IgnorePointer(
        child: Semantics(
          liveRegion: true,
          child: FadeTransition(
            opacity: _show,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, -.5),
                end: Offset.zero,
              ).animate(curve),
              child: Material(
                color: m.card,
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: MetroRadius.brXl,
                  side: BorderSide(color: tone, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(MetroSpacing.xs),
                  child: Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: tone.withValues(alpha: .14),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(MetroSpacing.xxs),
                          child: MetroMascot(
                            size: 56,
                            mood: widget.mood,
                            celebrate: true,
                          ),
                        ),
                      ),
                      MetroSpacing.gapSm,
                      Expanded(
                        child: Text(
                          widget.message,
                          style: context.text.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
