import 'package:flutter/foundation.dart';

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

/// Bảng giá P34 (`ticket_type` + `ticket_price`).
@immutable
class FareTable {
  const FareTable({required this.types, required this.singleTiers});

  final List<TicketType> types;
  final List<FareTier> singleTiers;
}
