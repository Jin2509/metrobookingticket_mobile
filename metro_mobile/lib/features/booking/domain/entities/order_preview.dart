import 'package:flutter/foundation.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';

/// Một dòng giảm giá: ưu đãi, hạng thành viên...
@immutable
class Discount {
  const Discount({required this.label, required this.amount});

  final String label;
  final int amount;
}

/// Kết quả `POST /api/orders/preview` (P30).
@immutable
class OrderPreview {
  const OrderPreview({
    required this.request,
    required this.typeName,
    required this.basePrice,
    required this.discounts,
    required this.pointsAvailable,
    required this.pointsToUse,
    required this.pointsValue,
    this.fromName,
    this.toName,
  });

  final BookingRequest request;
  final String typeName;
  final String? fromName;
  final String? toName;
  final int basePrice;
  final List<Discount> discounts;

  /// Điểm hiện có, số điểm dùng một lần đổi, giá trị quy đổi (₫).
  final int pointsAvailable;
  final int pointsToUse;
  final int pointsValue;

  bool get canUsePoints => pointsAvailable >= pointsToUse && pointsToUse > 0;

  int total({required bool usePoints}) {
    final afterDiscount =
        basePrice - discounts.fold(0, (sum, d) => sum + d.amount);
    final points = usePoints && canUsePoints ? pointsValue : 0;
    return (afterDiscount - points).clamp(0, basePrice).toInt();
  }
}
