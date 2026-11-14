import 'package:flutter/foundation.dart';

/// Mã vé chỉ dành cho người đã xác nhận sinh viên.
const studentTicketCode = 'MONTH_STUDENT';

/// Loại vé (`ticket_type`). Vé lượt tính giá theo số ga; vé ngày/tháng
/// giá cố định và không cần chọn ga (mục 7.2).
@immutable
class TicketType {
  const TicketType({
    required this.code,
    required this.name,
    required this.validity,
    this.price,
  });

  /// SINGLE, DAY, THREE_DAY, MONTH, MONTH_STUDENT.
  final String code;
  final String name;

  /// VD `Trong ngày`, `30 ngày`.
  final String validity;

  /// `null` với vé lượt (giá theo bậc số ga).
  final int? price;

  bool get needsStations => price == null;
}

/// Một bậc giá vé lượt: đi tối đa [maxStations] ga thì giá [price].
@immutable
class FareTier {
  const FareTier({required this.price, this.maxStations});

  /// `null` = từ bậc trước trở lên.
  final int? maxStations;
  final int price;
}

/// Vé lượt tính theo km giữa hai ga (`GET /api/v1/public/fares`).
@immutable
class SingleFare {
  const SingleFare({required this.perKm, required this.minFare});

  final int perKm;
  final int minFare;
}

/// Bảng giá P34. Vé lượt có [singleTiers] (bậc theo số ga) hoặc
/// [singleFare] (đơn giá/km của backend).
@immutable
class FareTable {
  const FareTable({
    required this.types,
    this.singleTiers = const [],
    this.singleFare,
  });

  final List<TicketType> types;
  final List<FareTier> singleTiers;
  final SingleFare? singleFare;

  /// Giá thấp nhất của vé lượt, `null` nếu chưa biết.
  int? get minSingleFare =>
      singleFare?.minFare ??
      (singleTiers.isEmpty
          ? null
          : singleTiers.map((t) => t.price).reduce((a, b) => a < b ? a : b));
}
