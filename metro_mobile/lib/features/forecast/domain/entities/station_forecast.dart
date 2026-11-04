import 'package:flutter/foundation.dart';

enum ForecastLevel {
  low,
  medium,
  high;

  static ForecastLevel parse(String? v) => switch (v) {
    'HIGH' => high,
    'MEDIUM' => medium,
    _ => low,
  };
}

/// Khoảng giờ thường đông, tính từ [fromHour] tới trước [toHour].
@immutable
class PeakWindow {
  const PeakWindow(this.fromHour, this.toHour);

  final int fromHour;
  final int toHour;

  bool contains(int hour) => hour >= fromHour && hour < toHour;
}

/// Kết quả `GET /api/stations/{id}/forecast`: độ đông trong ga theo giờ và mức
/// kẹt xe quanh ga. [source] cho biết cách tính (`RULE`, `HISTORY`, `ML`).
@immutable
class StationForecast {
  const StationForecast({
    required this.stationId,
    required this.source,
    required this.crowdByHour,
    required this.road,
    required this.peaks,
  });

  final String stationId;
  final String source;

  /// Giờ hoạt động của ga → mức đông, theo thứ tự giờ tăng dần.
  final Map<int, ForecastLevel> crowdByHour;
  final ForecastLevel road;
  final List<PeakWindow> peaks;

  ForecastLevel levelAt(int hour) => crowdByHour[hour] ?? ForecastLevel.low;

  PeakWindow? activePeak(int hour) =>
      peaks.where((p) => p.contains(hour)).firstOrNull;

  PeakWindow? nextPeak(int hour) =>
      peaks.where((p) => p.fromHour > hour).firstOrNull;
}

/// Gộp các giờ đông liền nhau thành khoảng giờ.
List<PeakWindow> peaksOf(Map<int, ForecastLevel> crowdByHour) {
  final peaks = <PeakWindow>[];
  int? start;
  int? last;
  for (final hour in crowdByHour.keys) {
    if (crowdByHour[hour] != ForecastLevel.high) continue;
    if (start != null && hour != last! + 1) {
      peaks.add(PeakWindow(start, last + 1));
      start = null;
    }
    start ??= hour;
    last = hour;
  }
  if (start != null) peaks.add(PeakWindow(start, last! + 1));
  return peaks;
}
