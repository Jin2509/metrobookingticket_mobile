import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/staff/shift/domain/entities/staff_shift.dart';
import 'package:metro_mobile/features/staff/staff_providers.dart';

/// Ca làm + ga phụ trách (giữ suốt phiên).
final shiftProvider = FutureProvider<StaffShift>(
  (ref) => ref.watch(shiftRepositoryProvider).getShift(),
);

/// Thống kê hôm nay; làm mới sau mỗi lượt quét.
final shiftStatsProvider = FutureProvider.autoDispose<ShiftStats>(
  (ref) => ref.watch(shiftRepositoryProvider).getTodayStats(),
);
