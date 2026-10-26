/// Cấu hình môi trường, truyền qua `--dart-define-from-file=config/<x>.json`.
///
/// Flavor dev/staging/prod chỉ đổi môi trường, không tách vai trò (P1).
abstract final class Env {
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const baseUrl = String.fromEnvironment('BASE_URL');
  static const wsUrl = String.fromEnvironment('WS_URL');

  static bool get isDev => flavor == 'dev';

  /// BASE_URL rỗng thì dùng Fake repository để demo offline.
  static bool get useFakeData => baseUrl.isEmpty;
}
