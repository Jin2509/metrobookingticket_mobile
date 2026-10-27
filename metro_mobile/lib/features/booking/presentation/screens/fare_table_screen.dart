import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/booking_controllers.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/fare_table/period_pass_list.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/fare_table/single_fare_tiers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P34. Loại vé & giá vé (UC7), nút Mua vé → P29.
class FareTableScreen extends ConsumerWidget {
  const FareTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.fareTableTitle)),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(MetroSpacing.md),
          child: MetroButton(
            label: context.l10n.buyTicket,
            icon: LucideIcons.ticketPlus,
            expand: true,
            onPressed: () => context.push(Routes.buy()),
          ),
        ),
      ),
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
