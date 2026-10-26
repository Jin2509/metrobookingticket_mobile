import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `● Trực tiếp` hoặc `◌ Đang kết nối lại…` cho dữ liệu WebSocket.
class LiveStatusChip extends StatelessWidget {
  const LiveStatusChip({required this.connected, super.key});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final color = connected ? m.success : m.accent;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: m.card,
          borderRadius: MetroRadius.brPill,
          border: Border.all(color: color.withValues(alpha: .5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (connected)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              )
            else
              SizedBox.square(
                dimension: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: color,
                ),
              ),
            const SizedBox(width: 6),
            Text(
              connected
                  ? context.l10n.liveConnected
                  : context.l10n.liveReconnecting,
              style: MetroTypography.label.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
