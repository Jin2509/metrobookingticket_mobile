import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/forecast/presentation/widgets/forecast_format.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_filter_controller.dart';

/// Chú giải màu ga, chỉ hiện khi bật lớp độ đông trên bản đồ.
class MapCrowdLegend extends ConsumerWidget {
  const MapCrowdLegend({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(mapFilterProvider.select((f) => f.showCrowd))) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: MetroSpacing.xs,
        left: MetroSpacing.screen,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.metro.card,
          borderRadius: MetroRadius.brPill,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MetroSpacing.sm,
            vertical: MetroSpacing.xxs,
          ),
          child: ForecastLegend(),
        ),
      ),
    );
  }
}
