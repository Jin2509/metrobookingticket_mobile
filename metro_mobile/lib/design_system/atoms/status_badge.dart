import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/atoms/status_badge_map.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhãn trạng thái dạng pill, ứng với `StatusBadge` trên web.
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, this.label, super.key});

  final String status;

  /// Ghi đè nhãn mặc định của bảng 3.5.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final (text, tone) = resolveStatus(context.l10n, status);
    final m = context.metro;
    final primary = context.colors.primary;
    final (bg, fg) = switch (tone) {
      StatusTone.success => (m.success.withValues(alpha: .15), m.success),
      StatusTone.muted => (m.muted, m.mutedForeground),
      StatusTone.accent => (m.accent.withValues(alpha: .2), m.accentForeground),
      StatusTone.primary => (primary.withValues(alpha: .15), primary),
      StatusTone.destructive => (
        m.destructive.withValues(alpha: .15),
        m.destructive,
      ),
      StatusTone.secondary => (m.secondary, context.colors.onSurface),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: MetroRadius.brPill),
      child: Text(
        label ?? text,
        style: MetroTypography.label.copyWith(color: fg),
      ),
    );
  }
}
