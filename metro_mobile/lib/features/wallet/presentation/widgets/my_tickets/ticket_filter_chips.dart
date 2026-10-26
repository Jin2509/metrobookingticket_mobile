import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/presentation/mappers/ticket_filter_labels.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Tất cả)(Chưa dùng)(Đang dùng)(Hết hạn)` (UC8-02).
class TicketFilterChips extends StatelessWidget {
  const TicketFilterChips({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TicketFilter value;
  final ValueChanged<TicketFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: MetroSpacing.screenPadding,
      child: Row(
        children: [
          for (final f in TicketFilter.values) ...[
            ChoiceChip(
              label: Text(ticketFilterLabel(context.l10n, f)),
              showCheckmark: false,
              selected: f == value,
              onSelected: (_) => onChanged(f),
            ),
            MetroSpacing.gapXs,
          ],
        ],
      ),
    );
  }
}
