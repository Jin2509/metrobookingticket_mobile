import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/booking_controllers.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/fare_table/period_pass_list.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/fare_table/single_fare_tiers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P34. Loại vé & giá vé (UC7, chỉ xem).
class FareTableScreen extends ConsumerWidget {
  const FareTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.fareTableTitle)),
      body: AsyncValueView(
        value: ref.watch(fareTableProvider),
        onRetry: () => ref.invalidate(fareTableProvider),
        data: (t) => ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [
            SingleFareTiers(tiers: t.singleTiers),
            MetroSpacing.gapMd,
            PeriodPassList(types: t.types),
            MetroSpacing.gapMd,
            Text(context.l10n.fareTableNote, style: context.text.bodySmall),
          ],
        ),
      ),
    );
  }
}
