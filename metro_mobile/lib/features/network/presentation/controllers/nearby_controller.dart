import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/permissions/location_consent.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/network_providers.dart';

enum NearbyStatus {
  idle,
  locating,
  denied,
  deniedForever,
  serviceOff,

  /// A1: chờ người dùng chạm bản đồ để chọn vị trí thay thế.
  picking,
  ready,
}

/// UC5-02. Vị trí chỉ giữ trong state của màn, không lưu (P5).
@immutable
class NearbyState {
  const NearbyState({
    this.status = NearbyStatus.idle,
    this.origin,
    this.stations = const [],
    this.pickedOnMap = false,
    this.error,
  });

  final NearbyStatus status;
  final (double, double)? origin;
  final List<NearbyStation> stations;

  /// A1: người dùng tự chọn vị trí trên bản đồ.
  final bool pickedOnMap;
  final String? error;
}

final nearbyControllerProvider =
    NotifierProvider.autoDispose<NearbyController, NearbyState>(
      NearbyController.new,
    );

class NearbyController extends Notifier<NearbyState> {
  @override
  NearbyState build() => const NearbyState();

  Future<void> locate() async {
    state = const NearbyState(status: NearbyStatus.locating);
    final result = await ref.read(locationServiceProvider).current();
    if (!ref.mounted) return;
    switch (result) {
      case LocationGranted(:final lat, :final lng):
        await _search(lat, lng, pickedOnMap: false);
      case LocationDenied(:final permanently):
        state = NearbyState(
          status: permanently
              ? NearbyStatus.deniedForever
              : NearbyStatus.denied,
        );
      case LocationServiceOff():
        state = const NearbyState(status: NearbyStatus.serviceOff);
    }
  }

  void startPicking() =>
      state = const NearbyState(status: NearbyStatus.picking);

  Future<void> pickOnMap(double lat, double lng) =>
      _search(lat, lng, pickedOnMap: true);

  Future<void> openSettings() =>
      ref.read(locationServiceProvider).openSettings();

  Future<void> _search(
    double lat,
    double lng, {
    required bool pickedOnMap,
  }) async {
    state = NearbyState(
      status: NearbyStatus.locating,
      origin: (lat, lng),
      pickedOnMap: pickedOnMap,
    );
    try {
      final list = await ref.read(findNearestProvider).call(lat, lng);
      if (!ref.mounted) return;
      state = NearbyState(
        status: NearbyStatus.ready,
        origin: (lat, lng),
        stations: list,
        pickedOnMap: pickedOnMap,
      );
    } on Failure catch (f) {
      if (!ref.mounted) return;
      state = NearbyState(status: NearbyStatus.ready, error: f.message);
    }
  }
}
