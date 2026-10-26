import 'package:flutter/painting.dart';
import 'package:metro_mobile/design_system/models/line_badge_data.dart';
import 'package:metro_mobile/design_system/models/station_option.dart';

/// Dữ liệu mẫu chỉ dùng trong gallery. Feature thật đọc từ API.
abstract final class GallerySample {
  static const line1 = LineBadgeData(
    id: 'L1',
    code: 'Tuyến 1',
    name: 'Bến Thành – Suối Tiên',
    color: Color(0xFFE2231A),
  );

  static const line2 = LineBadgeData(
    id: 'L2',
    code: 'Tuyến 2',
    name: 'Bến Thành – Tham Lương',
    color: Color(0xFFF7A800),
    planned: true,
  );

  static const benThanh = StationOption(
    id: 'BT',
    name: 'Bến Thành',
    lines: [line1, line2],
  );
  static const baSon = StationOption(id: 'BS', name: 'Ba Son', lines: [line1]);
  static const thuDuc = StationOption(
    id: 'TD',
    name: 'Thủ Đức',
    lines: [line1],
  );
  static const suoiTien = StationOption(
    id: 'ST',
    name: 'Suối Tiên',
    lines: [line1],
  );
  static const taoDan = StationOption(
    id: 'TDN',
    name: 'Tao Đàn',
    lines: [line2],
    active: false,
  );

  static const List<StationOption> stations = [
    benThanh,
    baSon,
    thuDuc,
    suoiTien,
    taoDan,
  ];

  static final validUntil = DateTime.utc(2026, 11, 23, 16, 59);
  static final parkedSince = DateTime.utc(2026, 10, 24, 0, 12);
}
