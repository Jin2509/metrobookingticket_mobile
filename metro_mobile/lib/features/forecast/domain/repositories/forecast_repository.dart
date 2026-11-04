import 'package:metro_mobile/features/forecast/domain/entities/station_forecast.dart';

abstract interface class ForecastRepository {
  /// Dự báo trong ngày [at] của một ga. [at] là giờ Việt Nam.
  Future<StationForecast> getStationForecast(String stationId, DateTime at);

  /// Mức đông hiện tại của mọi ga, dùng cho lớp màu trên bản đồ.
  Future<Map<String, ForecastLevel>> getNetworkCrowd(DateTime at);
}
