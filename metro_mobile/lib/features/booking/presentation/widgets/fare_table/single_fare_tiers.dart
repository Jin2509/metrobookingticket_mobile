import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/booking_confirm/discount_row.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Giá vé lượt: theo km ([fare]) hoặc theo bậc số ga ([tiers]).
class SingleFareTiers extends StatelessWidget {
  const SingleFareTiers({required this.tiers, this.fare, super.key});

  final List<FareTier> tiers;
  final SingleFare? fare;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (fare case final f?) {
      return SectionCard(
        title: l.singleFarePerKmTitle,
        child: Column(
          children: [
            DiscountRow(label: l.farePerKm, amount: f.perKm),
            DiscountRow(label: l.fareMinimum, amount: f.minFare),
          ],
        ),
      );
    }
    final rows = <Widget>[];
    var from = 1;
    for (final t in tiers) {
      final label = t.maxStations == null
          ? l.fareTierFrom(from)
          : from == t.maxStations
          ? l.stationCount(from)
          : l.fareTierRange(from, t.maxStations!);
      rows.add(DiscountRow(label: label, amount: t.price));
      from = (t.maxStations ?? from) + 1;
    }
    return SectionCard(
      title: l.singleFareTitle,
      child: Column(children: rows),
    );
  }
}
