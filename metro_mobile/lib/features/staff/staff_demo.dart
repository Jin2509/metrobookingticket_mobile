/// Phân công demo của `staff@metro.vn` (khi BASE_URL rỗng).
abstract final class StaffDemo {
  static const stationId = 'TD';
  static const stationName = 'Thủ Đức';
  static const shiftLabel = '06:00–14:00';
  static const lotId = 'PK2-TD';
  static const lotName = 'Bãi PK2 · Thủ Đức';

  /// Lượt đã soát trước khi mở app (cho số liệu ca giống thật).
  static const baseEntries = 412;
  static const baseExits = 389;
  static const baseRejected = 7;
}
