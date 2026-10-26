import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/parking/data/sources/parking_fake_source.dart';
import 'package:metro_mobile/features/parking/data/sources/parking_remote_source.dart';
import 'package:metro_mobile/features/parking/domain/repositories/parking_repository.dart';
import 'package:metro_mobile/features/parking/domain/usecases/parking_usecases.dart';

final parkingRepositoryProvider = Provider<ParkingRepository>(
  (ref) => Env.useFakeData
      ? ParkingFakeSource(ref.watch(demoLedgerProvider))
      : ParkingRemoteSource(ref.watch(dioProvider)),
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
