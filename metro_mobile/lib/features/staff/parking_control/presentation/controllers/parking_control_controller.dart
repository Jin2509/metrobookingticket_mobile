import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/qr/camera_scanner.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/entities/parking_control_entities.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/usecases/parking_control_usecases.dart';
import 'package:metro_mobile/features/staff/shift/presentation/controllers/shift_providers.dart';
import 'package:metro_mobile/features/staff/staff_providers.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/dedupe_scan.dart';

final lotStatusProvider = FutureProvider.autoDispose<LotStatus>((ref) async {
  final shift = await ref.watch(shiftProvider.future);
  return await ref
      .watch(parkingControlRepositoryProvider)
      .getLotStatus(shift.lotId);
});

final parkedVehiclesProvider = FutureProvider.autoDispose
    .family<List<ParkedVehicle>, String>((ref, query) async {
      final shift = await ref.watch(shiftProvider.future);
      return await GetParkedVehicles(
        ref.watch(parkingControlRepositoryProvider),
      ).call(shift.lotId, query: query);
    });

@immutable
class ParkingControlState {
  const ParkingControlState({this.check, this.error, this.busy = false});

  final ParkingCheck? check;

  /// 409 quá hạn / đã đổi trạng thái, sai bãi, sai loại QR.
  final String? error;
  final bool busy;
}

final parkingControlProvider =
    NotifierProvider<ParkingControlController, ParkingControlState>(
      ParkingControlController.new,
    );

/// S20/S21: quét QR gửi xe, giữ kết quả gần nhất để hiển thị.
class ParkingControlController extends Notifier<ParkingControlState> {
  final _dedupe = DedupeScan();

  @override
  ParkingControlState build() => const ParkingControlState();

  /// Trả `true` khi đã có kết quả (để màn quét đóng lại).
  Future<bool> onRead(ScanRead read) async {
    if (state.busy || read is! ScanDecoded) return false;
    if (!_dedupe.accept(read.payload.token)) return false;
    state = const ParkingControlState(busy: true);
    try {
      final shift = await ref.read(shiftProvider.future);
      final check = await CheckParkingQr(
        ref.read(parkingControlRepositoryProvider),
      ).call(read.payload, shift.lotId);
      state = ParkingControlState(check: check);
    } on Failure catch (f) {
      state = ParkingControlState(error: f.message);
    }
    ref
      ..invalidate(parkedVehiclesProvider)
      ..invalidate(lotStatusProvider);
    return true;
  }
}
