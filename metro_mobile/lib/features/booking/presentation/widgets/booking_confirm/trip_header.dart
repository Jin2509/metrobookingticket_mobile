import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Vé lượt · Bến Thành → Thủ Đức`.
class TripHeader extends StatelessWidget {
  const TripHeader({required this.preview, super.key});

  final OrderPreview preview;

  @override
  Widget build(BuildContext context) {
    final p = preview;
    return MetroCard(
      child: Row(
        children: [
          Icon(LucideIcons.ticket, color: context.colors.primary, size: 28),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.typeName, style: context.text.titleMedium),
                if (p.fromName != null && p.toName != null)
                  RouteLabel(
                    from: p.fromName!,
                    to: p.toName!,
                    style: context.text.bodyMedium,
                  )
                else
                  Text(
                    context.l10n.noStationsNeeded,
                    style: context.text.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
