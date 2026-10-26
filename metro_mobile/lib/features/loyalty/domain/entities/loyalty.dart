import 'package:flutter/foundation.dart';

/// Hạng + điểm (UC11-02/03, `membership_tier`).
@immutable
class MemberSummary {
  const MemberSummary({
    required this.tierName,
    required this.points,
    required this.benefits,
    this.nextTierName,
    this.pointsToNext = 0,
    this.progress = 1,
  });

  final String tierName;
  final int points;
  final List<String> benefits;
  final String? nextTierName;
  final int pointsToNext;

  /// 0..1 trong hạng hiện tại.
  final double progress;
}

/// Ưu đãi đang có (UC11-01).
@immutable
class Promotion {
  const Promotion({
    required this.id,
    required this.title,
    required this.discountLabel,
    required this.validUntil,
    this.description,
  });

  final String id;
  final String title;

  /// `-20%`, `-5.000 ₫`.
  final String discountLabel;
  final DateTime validUntil;
  final String? description;
}

/// Một dòng `loyalty_transaction`: `+16  Vé lượt BT→TĐ  20/10`.
@immutable
class PointsEntry {
  const PointsEntry({
    required this.delta,
    required this.title,
    required this.createdAt,
  });

  final int delta;
  final String title;
  final DateTime createdAt;
}
