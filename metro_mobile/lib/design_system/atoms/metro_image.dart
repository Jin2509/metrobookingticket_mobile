import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';

/// Ảnh từ `assets/...` hoặc URL mạng; thiếu/lỗi thì hiện nền + icon.
class MetroImage extends StatelessWidget {
  const MetroImage({required this.src, this.aspectRatio = 16 / 9, super.key});

  final String? src;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final placeholder = ColoredBox(
      color: m.muted,
      child: Center(
        child: Icon(LucideIcons.trainFront, color: m.mutedForeground),
      ),
    );
    final s = src;
    Widget error(BuildContext _, Object _, StackTrace? _) => placeholder;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: s == null
          ? placeholder
          : s.startsWith('assets/')
          ? Image.asset(s, fit: BoxFit.cover, errorBuilder: error)
          : Image.network(s, fit: BoxFit.cover, errorBuilder: error),
    );
  }
}
