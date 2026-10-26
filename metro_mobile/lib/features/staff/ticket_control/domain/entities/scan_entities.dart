/// Chế độ quét (mục 7.4), khớp `/s/scan?mode=`.
enum ScanMode {
  entry('ENTRY', 'Vào ga'),
  exit('EXIT', 'Ra ga');

  ScanMode(this.code, this.label);
  final String code;
  final String label;

  static ScanMode parse(String? v) => v == 'EXIT' ? exit : entry;
}

/// Lý do từ chối (`reject_reason`) và thông điệp hiển thị.
enum RejectReason {
  expired('Vé hết hạn'),
  used('Vé đã được sử dụng'),
  alreadyIn('Vé đã được check-in'),
  notIn('Vé chưa check-in vào ga'),
  wrongStation('Check-out sai ga'),
  notFound('Vé không tồn tại'),
  wrongKind('Mã QR không đúng loại'),
  forbidden('Bạn chỉ được soát vé tại ga được phân công');

  RejectReason(this.message);
  final String message;
}

/// Kết quả một lượt soát vé (S11).
sealed class ScanResult {
  const ScanResult({required this.mode, required this.at, this.code});

  final ScanMode mode;
  final DateTime at;

  /// Mã vé (`VE-…`), không bao giờ có tên/SĐT hành khách.
  final String? code;
}

class ScanValid extends ScanResult {
  const ScanValid({
    required super.mode,
    required super.at,
    required String super.code,
    required this.typeName,
    required this.validUntil,
    this.route,
  });

  final String typeName;
  final DateTime validUntil;

  /// `Bến Thành – Thủ Đức` (vé lượt).
  final String? route;
}

class ScanInvalid extends ScanResult {
  const ScanInvalid({
    required super.mode,
    required super.at,
    required this.reason,
    super.code,
    this.route,
    this.currentStation,
  });

  final RejectReason reason;
  final String? route;

  /// Ga hiện tại (khi check-out sai ga).
  final String? currentStation;
}
