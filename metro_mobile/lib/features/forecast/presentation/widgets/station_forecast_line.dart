import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/forecast/forecast_providers.dart';
import 'package:metro_mobile/features/forecast/presentation/widgets/forecast_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Một dòng giờ đông của ga trong thẻ "Tàu sắp đến" ở Trang chủ, chạm để xem
/// chi tiết ga. Không có dữ liệu thì ẩn.
class StationForecastLine extends ConsumerWidget {
  const StationForecastLine({required this.stationId, super.key});

  final String stationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(stationForecastProvider(stationId)).value;
    if (f == null) return const SizedBox.shrink();
    final hour = forecastNow().hour;
    final color = forecastColor(context, f.levelAt(hour));
    return InkWell(
      borderRadius: MetroRadius.brMd,
      onTap: () => context.push(Routes.stationDetail(stationId)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xs),
        child: Row(
          children: [
            Icon(LucideIcons.users, size: 16, color: color),
            MetroSpacing.gapXs,
            Expanded(
              child: Text(
                forecastPeakLine(context.l10n, f, hour),
                style: context.text.labelMedium,
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: context.metro.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}
