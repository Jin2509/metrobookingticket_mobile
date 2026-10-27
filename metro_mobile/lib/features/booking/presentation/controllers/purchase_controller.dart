import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';

final purchaseProvider = NotifierProvider.autoDispose
    .family<PurchaseController, BookingRequest, BookingRequest>(
      PurchaseController.new,
    );

/// P29: lựa chọn loại vé + ga đi/đến, khởi tạo từ query của route.
class PurchaseController extends Notifier<BookingRequest> {
  PurchaseController(this.initial);
  final BookingRequest initial;

  @override
  BookingRequest build() => initial;

  void setType(String code) => state = BookingRequest(
    typeCode: code,
    fromId: state.fromId,
    toId: state.toId,
  );

  void setFrom(String id) => state = BookingRequest(
    typeCode: state.typeCode,
    fromId: id,
    toId: state.toId,
  );

  void setTo(String id) => state = BookingRequest(
    typeCode: state.typeCode,
    fromId: state.fromId,
    toId: id,
  );

  void swap() => state = BookingRequest(
    typeCode: state.typeCode,
    fromId: state.toId,
    toId: state.fromId,
  );
}
