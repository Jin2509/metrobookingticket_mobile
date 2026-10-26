import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/staff/parking_control/data/sources/parking_control_fake_source.dart';
import 'package:metro_mobile/features/staff/parking_control/data/sources/parking_control_remote_source.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/repositories/parking_control_repository.dart';
import 'package:metro_mobile/features/staff/scan_history/data/sources/scan_history_sources.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/repositories/scan_history_repository.dart';
import 'package:metro_mobile/features/staff/shift/data/sources/shift_sources.dart';
import 'package:metro_mobile/features/staff/shift/domain/repositories/shift_repository.dart';
import 'package:metro_mobile/features/staff/ticket_control/data/sources/ticket_control_fake_source.dart';
import 'package:metro_mobile/features/staff/ticket_control/data/sources/ticket_control_remote_source.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/repositories/ticket_control_repository.dart';

/// DI cho khu Staff (ca làm, soát vé, gửi xe, lịch sử).
final shiftRepositoryProvider = Provider<ShiftRepository>(
  (ref) => Env.useFakeData
      ? ShiftFakeSource(ref.watch(demoLedgerProvider))
      : ShiftRemoteSource(ref.watch(dioProvider)),
);

final ticketControlRepositoryProvider = Provider<TicketControlRepository>(
  (ref) => Env.useFakeData
      ? TicketControlFakeSource(ref.watch(demoLedgerProvider))
      : TicketControlRemoteSource(ref.watch(dioProvider)),
);

final parkingControlRepositoryProvider = Provider<ParkingControlRepository>(
  (ref) => Env.useFakeData
      ? ParkingControlFakeSource(ref.watch(demoLedgerProvider))
      : ParkingControlRemoteSource(ref.watch(dioProvider)),
);

final scanHistoryRepositoryProvider = Provider<ScanHistoryRepository>(
  (ref) => Env.useFakeData
      ? ScanHistoryFakeSource(ref.watch(demoLedgerProvider))
      : ScanHistoryRemoteSource(ref.watch(dioProvider)),
);
