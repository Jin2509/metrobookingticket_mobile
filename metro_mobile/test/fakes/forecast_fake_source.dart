import 'package:metro_mobile/features/forecast/domain/entities/station_forecast.dart';
import 'package:metro_mobile/features/forecast/domain/repositories/forecast_repository.dart';

enum _Kind { center, commute, hub }

/// Bảng quy tắc minh họa theo loại ga, giờ và ngày trong tuần. Số liệu do app
/// tự đặt để demo, chưa phải dữ liệu đo. Backend sẽ thay bằng API thật.
class ForecastFakeSource implements ForecastRepository {
  const ForecastFakeSource();

  static const _firstHour = 5;
  static const _lastHour = 22;

  static const _kinds = {
    'BT': _Kind.center,
    'NHTP': _Kind.center,
    'BS': _Kind.center,
    'VT': _Kind.commute,
    'TC': _Kind.commute,
    'TDI': _Kind.commute,
    'AP': _Kind.commute,
    'RC': _Kind.commute,
    'PL': _Kind.commute,
    'BTH': _Kind.commute,
    'TD': _Kind.commute,
    'CNC': _Kind.hub,
    'DHQG': _Kind.hub,
    'ST': _Kind.hub,
  };

  /// Ga gần các trục đường hay kẹt: mức kẹt xe cao hơn độ đông một bậc.
  static const _jamProne = {'BT', 'BS', 'AP', 'RC', 'TD', 'ST'};

  /// Giờ đông và giờ vừa theo loại ga, ngày thường trước rồi cuối tuần.
  static (Set<int>, Set<int>) _profile(_Kind kind, bool weekend) =>
      switch ((kind, weekend)) {
        (_Kind.center, false) => ({7, 8, 17, 18}, {9, 11, 12, 16, 19, 20}),
        (_Kind.center, true) => (
          {18, 19, 20},
          {10, 11, 12, 13, 14, 15, 16, 17, 21},
        ),
        (_Kind.commute, false) => ({7, 8, 17, 18}, {6, 9, 16, 19}),
        (_Kind.commute, true) => (<int>{}, {9, 10, 17, 18, 19}),
        (_Kind.hub, false) => ({6, 7, 16, 17}, {8, 11, 12, 15, 18}),
        (_Kind.hub, true) => ({16, 17}, {8, 9, 10, 11, 12, 13, 14, 15}),
      };

  static ForecastLevel _level(String id, DateTime at, int hour) {
    final kind = _kinds[id] ?? _Kind.commute;
    final (high, medium) = _profile(kind, at.weekday >= DateTime.saturday);
    if (high.contains(hour)) return ForecastLevel.high;
    return medium.contains(hour) ? ForecastLevel.medium : ForecastLevel.low;
  }

  @override
  Future<StationForecast> getStationForecast(
    String stationId,
    DateTime at,
  ) async {
    final crowd = {
      for (var h = _firstHour; h <= _lastHour; h++) h: _level(stationId, at, h),
    };
    final now = _level(stationId, at, at.hour);
    return StationForecast(
      stationId: stationId,
      source: 'RULE',
      crowdByHour: crowd,
      road: _jamProne.contains(stationId) && now != ForecastLevel.low
          ? ForecastLevel.high
          : now,
      peaks: peaksOf(crowd),
    );
  }

  @override
  Future<Map<String, ForecastLevel>> getNetworkCrowd(DateTime at) async => {
    for (final id in _kinds.keys) id: _level(id, at, at.hour),
  };
}
