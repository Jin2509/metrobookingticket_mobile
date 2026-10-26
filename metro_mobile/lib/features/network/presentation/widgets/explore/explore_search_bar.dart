import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `🔍 Tìm ga…` – mở StationPickerSheet rồi vào chi tiết ga.
class ExploreSearchBar extends ConsumerWidget {
  const ExploreSearchBar({super.key});

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final catalog = await ref.read(catalogProvider.future);
    if (!context.mounted) return;
    final picked = await StationPickerSheet.show(
      context,
      title: context.l10n.searchStation,
      stations: catalog.options,
    );
    if (picked != null && context.mounted) {
      await context.push(Routes.stationDetail(picked.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = context.metro;
    return Semantics(
      button: true,
      label: context.l10n.searchStation,
      child: MetroCard(
        onTap: () => _open(context, ref),
        padding: const EdgeInsets.symmetric(
          horizontal: MetroSpacing.md,
          vertical: MetroSpacing.sm,
        ),
        // 24 + 2×12 padding = vùng chạm 48dp.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 24),
          child: Row(
            children: [
              Icon(LucideIcons.search, size: 20, color: m.mutedForeground),
              MetroSpacing.gapSm,
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
    );
  }
}
