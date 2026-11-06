/// Cấu hình môi trường, truyền qua `--dart-define-from-file=config/<x>.json`.
///
/// Flavor dev/staging/prod chỉ đổi môi trường, không tách vai trò (P1).
abstract final class Env {
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const baseUrl = String.fromEnvironment('BASE_URL');
  static const wsUrl = String.fromEnvironment('WS_URL');

  static bool get isDev => flavor == 'dev';

  /// Backend mới có API auth và hồ sơ. `FAKE_FEATURES=true` giữ các tính năng
  /// còn lại (vé, ga, tuyến...) trên Fake repository khi đã trỏ tới backend.
  static const fakeFeatures = bool.fromEnvironment('FAKE_FEATURES');

  /// BASE_URL rỗng thì dùng Fake source để demo offline.
  static bool get useFakeAuth => baseUrl.isEmpty;

  /// Các tính năng ngoài auth.
  static bool get useFakeData => baseUrl.isEmpty || fakeFeatures;

  /// Tuyến & ga đã có API thật (`/api/v1/lines`, `/api/v1/stations`), không
  /// theo `FAKE_FEATURES`. `FAKE_NETWORK=true` để dùng lại dữ liệu demo.
  static const fakeNetwork = bool.fromEnvironment('FAKE_NETWORK');
  static bool get useFakeNetwork => baseUrl.isEmpty || fakeNetwork;
}
