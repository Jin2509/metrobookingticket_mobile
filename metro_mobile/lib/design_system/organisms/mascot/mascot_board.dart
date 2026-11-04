import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/metro_mascot.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Bảng lớn giữa màn hình để Futu báo sự kiện quan trọng như đăng nhập, đăng
/// xuất. Tự ẩn và không chặn thao tác, kể cả khi màn phía sau đang chuyển.
abstract final class MascotBoard {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required MascotMood mood,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_current?.mounted ?? false) _current!.remove();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _BoardView(
        title: title,
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
    overlay.insert(entry);
  }
}

class _BoardView extends StatefulWidget {
  const _BoardView({
    required this.title,
    required this.message,
    required this.mood,
    required this.onDone,
  });

  final String title;
  final String message;
  final MascotMood mood;
  final VoidCallback onDone;

  @override
  State<_BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<_BoardView>
    with SingleTickerProviderStateMixin {
  static const _visible = Duration(milliseconds: 2600);

  late final _show = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
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
    return IgnorePointer(
      child: FadeTransition(
        opacity: _show,
        child: ColoredBox(
          color: const Color(0x66060F1A),
          child: Center(
            child: ScaleTransition(
              scale: CurvedAnimation(parent: _show, curve: Curves.easeOutBack),
              child: Semantics(
                liveRegion: true,
                child: Material(
                  color: context.metro.card,
                  elevation: 12,
                  borderRadius: MetroRadius.brXxl,
                  child: SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(MetroSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MetroMascot(
                            size: 150,
                            mood: widget.mood,
                            celebrate: widget.mood == MascotMood.happy,
                          ),
                          MetroSpacing.gapMd,
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: context.text.titleLarge,
                          ),
                          MetroSpacing.gapXxs,
                          Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: context.text.bodyMedium,
                          ),
                        ],
                      ),
                    ),
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
