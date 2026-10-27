import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Một loại vé để chọn: `◉ Vé ngày · Trong ngày        40.000 ₫`.
/// Vé lượt hiện giá thấp nhất `từ 7.000 ₫` (theo số ga).
class TicketTypeOption extends StatelessWidget {
  const TicketTypeOption({
    required this.type,
    required this.selected,
    required this.minSingleFare,
    required this.onTap,
    super.key,
  });

  final TicketType type;
  final bool selected;
  final int? minSingleFare;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final primary = context.colors.primary;
    final price = type.price;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: selected ? primary.withValues(alpha: .08) : context.metro.card,
        shape: RoundedRectangleBorder(
          borderRadius: MetroRadius.brLg,
          side: BorderSide(
            color: selected ? primary : context.metro.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: MetroRadius.brLg,
          child: Padding(
            padding: const EdgeInsets.all(MetroSpacing.sm),
            child: Row(
              children: [
                Icon(
                  selected ? LucideIcons.circleCheck : LucideIcons.circle,
                  color: selected ? primary : context.metro.mutedForeground,
                ),
                MetroSpacing.gapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type.name, style: context.text.titleSmall),
                      Text(
                        type.needsStations
                            ? l.singleTicketHint(type.validity)
                            : type.validity,
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  price != null
                      ? money(price)
                      : minSingleFare == null
                      ? ''
                      : l.fromPrice(money(minSingleFare!)),
                  style: context.text.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
