import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/features/booking/domain/repositories/booking_repository.dart';

/// UC7 Loại vé & giá vé (P34, chỉ xem).
class GetFareTable {
  const GetFareTable(this._repo);
  final BookingRepository _repo;

  Future<FareTable> call() => _repo.getFareTable();
}
