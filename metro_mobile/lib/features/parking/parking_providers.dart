import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/parking/data/sources/parking_remote_source.dart';
import 'package:metro_mobile/features/parking/domain/repositories/parking_repository.dart';
import 'package:metro_mobile/features/parking/domain/usecases/parking_usecases.dart';

final parkingRepositoryProvider = Provider<ParkingRepository>(
  (ref) => ParkingRemoteSource(ref.watch(dioProvider)),
);

final getParkingLotsProvider = Provider(
  (ref) => GetParkingLots(ref.watch(parkingRepositoryProvider)),
);
final previewParkingProvider = Provider(
  (ref) => PreviewParking(ref.watch(parkingRepositoryProvider)),
);
final createParkingPaymentProvider = Provider(
  (ref) => CreateParkingPayment(ref.watch(parkingRepositoryProvider)),
);
