import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ đầu Trang chủ: tìm ga rồi mở bản đồ tại ga đó, ba việc chính, bảng giá.
class QuickBookCard extends ConsumerWidget {
  const QuickBookCard({super.key});

  Future<void> _search(BuildContext context, WidgetRef ref) async {
    final catalog = await ref.read(catalogProvider.future);
    if (!context.mounted) return;
    final picked = await StationPickerSheet.show(
      context,
      title: context.l10n.searchStation,
      stations: catalog.options,
    );
    if (picked == null || !context.mounted) return;
    ref.read(quickBookProvider.notifier).setFrom(picked.id);
    await context.push(Routes.map(stationId: picked.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = context.metro;
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            label: context.l10n.searchStation,
            excludeSemantics: true,
            child: Material(
              color: m.muted,
              borderRadius: MetroRadius.brLg,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _search(context, ref),
                child: SizedBox(
                  height: MetroSpacing.minTouch,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MetroSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.search,
                          size: 20,
                          color: m.mutedForeground,
                        ),
                        MetroSpacing.gapXs,
                        Expanded(
                          child: Text(
                            context.l10n.stationSearchHint,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.bodyMedium?.copyWith(
                              color: m.mutedForeground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          MetroSpacing.gapSm,
          const HomeQuickActions(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push(Routes.fares),
              child: Text(context.l10n.fares),
            ),
          ),
        ],
      ),
    );
  }
}
