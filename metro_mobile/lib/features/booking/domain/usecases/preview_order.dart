import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/repositories/booking_repository.dart';

/// UC8-01 bước 1: giá, ưu đãi, giảm theo hạng, đổi điểm.
/// A1: vé lượt thiếu ga hoặc trùng ga thì báo lỗi trước khi gọi API.
class PreviewOrder {
  const PreviewOrder(this._repo);
  final BookingRepository _repo;

  static const singleCode = 'SINGLE';

  Future<OrderPreview> call(BookingRequest r) {
    if (r.typeCode == singleCode) {
      if (r.fromId == null || r.toId == null) {
        throw const ValidationFailure('Vui lòng chọn ga đi và ga đến');
      }
      if (r.fromId == r.toId) {
        throw const ValidationFailure('Ga đi và ga đến trùng nhau');
      }
    }
    return _repo.previewOrder(r);
  }
}
