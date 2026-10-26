import 'package:flutter/foundation.dart';

/// Một lượt quét trong ca (S30). Chỉ mã vé/biển số, không có PII.
@immutable
class ScanLogEntry {
  const ScanLogEntry({
    required this.at,
    required this.parking,
    required this.entry,
    required this.code,
    required this.valid,
    required this.label,
  });

  final DateTime at;

  /// `true` = gửi xe, `false` = vé.
  final bool parking;

  /// `true` = vào, `false` = ra.
  final bool entry;

  /// `VE-80021` hoặc biển số.
  final String code;
  final bool valid;

  /// Loại vé hoặc lý do từ chối.
  final String label;
}

enum ScanLogFilter {
  all('Tất cả'),
  tickets('Vé'),
  parking('Gửi xe'),
  rejected('Từ chối');

  ScanLogFilter(this.label);
  final String label;

  bool matches(ScanLogEntry e) => switch (this) {
    all => true,
    tickets => !e.parking,
    parking => e.parking,
    rejected => !e.valid,
  };
}
