import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/usecases/parking_usecases.dart';
import 'package:metro_mobile/features/parking/parking_providers.dart';

final parkingLotsProvider = FutureProvider<List<ParkingLot>>(
  (ref) => ref.watch(getParkingLotsProvider).call(),
);

/// Phí + lượt còn hiệu lực cho một yêu cầu hợp lệ.
final parkingPreviewProvider = FutureProvider.autoDispose
    .family<ParkingPreview, ParkingRequest>(
      (ref, r) => ref.watch(previewParkingProvider).call(r),
    );

@immutable
class ParkingFormState {
  const ParkingFormState({
    this.lotId,
    this.vehicle = 'MOTORBIKE',
    this.plate = '',
    this.package = ParkingPackage.turn,
    this.submitting = false,
    this.error,
  });

  final String? lotId;
  final String vehicle;
  final String plate;
  final ParkingPackage package;
  final bool submitting;
  final String? error;

  /// A1: lỗi biển số (chỉ hiện khi đã gõ).
  String? get plateError => plate.isEmpty && vehicle != bicycle
      ? null
      : validatePlate(vehicle, plate);

  /// Yêu cầu đủ điều kiện để xem phí. `defaultLotId`: bãi đầu danh sách
  /// khi người dùng chưa chọn.
  ParkingRequest? requestFor(String defaultLotId) =>
      validatePlate(vehicle, plate) != null
      ? null
      : ParkingRequest(
          lotId: lotId ?? defaultLotId,
          vehicle: vehicle,
          plate: plate.trim().toUpperCase(),
          package: package,
        );

  ParkingFormState copyWith({
    String? lotId,
    String? vehicle,
    String? plate,
    ParkingPackage? package,
    bool submitting = false,
    String? error,
  }) => ParkingFormState(
    lotId: lotId ?? this.lotId,
    vehicle: vehicle ?? this.vehicle,
    plate: plate ?? this.plate,
    package: package ?? this.package,
    submitting: submitting,
    error: error,
  );
}

final parkingFormProvider =
    NotifierProvider.autoDispose<ParkingFormController, ParkingFormState>(
      ParkingFormController.new,
    );

/// P35. Giữ lựa chọn của form, tạo thanh toán gửi xe.
class ParkingFormController extends Notifier<ParkingFormState> {
  @override
  ParkingFormState build() => const ParkingFormState();

  void setLot(String id) => state = state.copyWith(lotId: id);
  void setVehicle(String v) => state = state.copyWith(vehicle: v);
  void setPlate(String p) => state = state.copyWith(plate: p);
  void setPackage(ParkingPackage p) => state = state.copyWith(package: p);

  /// Trả `orderId` để mở màn QR thanh toán.
  Future<String?> pay(String defaultLotId) async {
    final r = state.requestFor(defaultLotId);
    if (r == null || state.submitting) return null;
    state = state.copyWith(submitting: true);
    try {
      final id = await ref.read(createParkingPaymentProvider).call(r);
      if (ref.mounted) state = state.copyWith();
      return id;
    } on Failure catch (f) {
      if (ref.mounted) state = state.copyWith(error: f.message);
      return null;
    }
  }
}
