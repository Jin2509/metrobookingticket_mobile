import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/features/forecast/data/sources/forecast_fake_source.dart';
import 'package:metro_mobile/features/forecast/domain/entities/station_forecast.dart';

void main() {
  const source = ForecastFakeSource();
  final wednesday = DateTime(2026, 11, 4, 10);
  final saturday = DateTime(2026, 11, 7, 10);

  test('gộp giờ đông liền nhau thành khoảng giờ', () async {
    final f = await source.getStationForecast('BT', wednesday);
    expect(f.peaks.map((p) => (p.fromHour, p.toHour)), [(7, 9), (17, 19)]);
  });

  test('tìm giờ đông hiện tại và kế tiếp', () async {
    final f = await source.getStationForecast('BT', wednesday);
    expect(f.activePeak(8)?.toHour, 9);
    expect(f.activePeak(10), isNull);
    expect(f.nextPeak(10)?.fromHour, 17);
    expect(f.nextPeak(20), isNull);
  });

  test('cuối tuần khác ngày thường', () async {
    final f = await source.getStationForecast('BT', saturday);
    expect(f.peaks.map((p) => (p.fromHour, p.toHour)), [(18, 21)]);
  });

  test('ga dễ kẹt xe có mức kẹt cao hơn độ đông', () async {
    final f = await source.getStationForecast('BT', wednesday);
    expect(f.levelAt(10), ForecastLevel.low);
    final noon = await source.getStationForecast(
      'BT',
      DateTime(2026, 11, 4, 12),
    );
    expect(noon.levelAt(12), ForecastLevel.medium);
    expect(noon.road, ForecastLevel.high);
  });

  test('có mức đông hiện tại cho các ga trên bản đồ', () async {
    final crowd = await source.getNetworkCrowd(DateTime(2026, 11, 4, 8));
    expect(crowd['BT'], ForecastLevel.high);
    expect(crowd.length, 14);
  });
}
