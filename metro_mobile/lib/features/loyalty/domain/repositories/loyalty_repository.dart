import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';

abstract interface class LoyaltyRepository {
  Future<MemberSummary> getSummary();
  Future<List<Promotion>> getPromotions();
  Future<List<PointsEntry>> getPointsHistory();
}
