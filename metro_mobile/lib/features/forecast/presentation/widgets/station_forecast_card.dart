import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/forecast/domain/entities/station_forecast.dart';
import 'package:metro_mobile/features/forecast/forecast_providers.dart';
import 'package:metro_mobile/features/forecast/presentation/widgets/forecast_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chi tiết ga: biểu đồ độ đông theo giờ, giờ đông và mức kẹt xe quanh ga.
class StationForecastCard extends ConsumerWidget {
  const StationForecastCard({required this.stationId, super.key});

  final String stationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(stationForecastProvider(stationId)).value;
    if (f == null) return const SizedBox.shrink();
    final l = context.l10n;
    final hour = forecastNow().hour;
    final peakLine = forecastPeakLine(l, f, hour);
    final road = forecastRoadLabel(l, f.road);
    return SectionCard(
      title: l.forecastTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: '${l.forecastTitle}. $peakLine',
            excludeSemantics: true,
            child: _HourBars(forecast: f, hour: hour),
          ),
          MetroSpacing.gapXs,
          const Center(child: ForecastLegend()),
          MetroSpacing.gapSm,
          _Fact(
            icon: LucideIcons.users,
            color: forecastColor(context, f.levelAt(hour)),
            text: peakLine,
          ),
          MetroSpacing.gapXxs,
          _Fact(
            icon: LucideIcons.car,
            color: forecastColor(context, f.road),
            text: l.forecastRoadLine(road),
          ),
          MetroSpacing.gapXs,
          Text(l.forecastEstimate, style: context.text.labelSmall),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        MetroSpacing.gapXs,
        Expanded(child: Text(text, style: context.text.bodyMedium)),
      ],
    );
  }
}

class _HourBars extends StatelessWidget {
  const _HourBars({required this.forecast, required this.hour});

  final StationForecast forecast;
  final int hour;

  static const _height = {
    ForecastLevel.low: .3,
    ForecastLevel.medium: .6,
    ForecastLevel.high: 1.0,
  };
  static const _labelled = {6, 12, 18};

  @override
  Widget build(BuildContext context) {
    final hours = forecast.crowdByHour;
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final MapEntry(key: h, value: level) in hours.entries)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor: _height[level],
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          // Giờ hiện tại đậm hơn để dễ thấy mình đang ở đâu.
                          color: forecastColor(
                            context,
                            level,
                          ).withValues(alpha: h == hour ? 1 : .4),
                          borderRadius: MetroRadius.brPill,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        MetroSpacing.gapXxs,
        Row(
          children: [
            for (final h in hours.keys)
              Expanded(
                child: Center(
                  child: Text(
                    _labelled.contains(h) ? '${h}h' : '',
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: context.text.labelSmall,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
