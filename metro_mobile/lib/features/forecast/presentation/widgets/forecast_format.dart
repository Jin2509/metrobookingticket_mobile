import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/forecast/domain/entities/station_forecast.dart';
import 'package:metro_mobile/l10n/l10n.dart';

Color forecastColor(BuildContext context, ForecastLevel level) =>
    switch (level) {
      ForecastLevel.low => context.metro.success,
      ForecastLevel.medium => context.metro.accent,
      ForecastLevel.high => context.metro.destructive,
    };

String forecastLevelLabel(AppLocalizations l, ForecastLevel level) =>
    switch (level) {
      ForecastLevel.low => l.forecastLevelLow,
      ForecastLevel.medium => l.forecastLevelMedium,
      ForecastLevel.high => l.forecastLevelHigh,
    };

String forecastRoadLabel(AppLocalizations l, ForecastLevel level) =>
    switch (level) {
      ForecastLevel.low => l.forecastRoadLow,
      ForecastLevel.medium => l.forecastRoadMedium,
      ForecastLevel.high => l.forecastRoadHigh,
    };

String forecastHour(int hour) => '${hour.toString().padLeft(2, '0')}:00';

/// `Đang đông, thường đến 19:00` / `Thường đông 17:00–19:00` / không còn giờ đông.
String forecastPeakLine(AppLocalizations l, StationForecast f, int hour) {
  final active = f.activePeak(hour);
  if (active != null) return l.forecastNowPeak(forecastHour(active.toHour));
  final next = f.nextPeak(hour);
  if (next == null) return l.forecastNoPeak;
  return l.forecastNextPeak(
    forecastHour(next.fromHour),
    forecastHour(next.toHour),
  );
}

/// Chú giải ba mức đông.
class ForecastLegend extends StatelessWidget {
  const ForecastLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final level in ForecastLevel.values) ...[
          if (level != ForecastLevel.low) MetroSpacing.gapSm,
          DecoratedBox(
            decoration: BoxDecoration(
              color: forecastColor(context, level),
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(dimension: 10),
          ),
          MetroSpacing.gapXxs,
          Text(
            forecastLevelLabel(context.l10n, level),
            style: context.text.labelSmall,
          ),
        ],
      ],
    );
  }
}
