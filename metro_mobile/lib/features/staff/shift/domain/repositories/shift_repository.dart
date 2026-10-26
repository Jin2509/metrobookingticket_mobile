import 'package:metro_mobile/features/staff/shift/domain/entities/staff_shift.dart';

abstract interface class ShiftRepository {
  Future<StaffShift> getShift();
  Future<ShiftStats> getTodayStats();
}
