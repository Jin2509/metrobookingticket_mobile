import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_remote_source.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_source.dart';
import 'package:metro_mobile/features/booking/domain/repositories/booking_repository.dart';
import 'package:metro_mobile/features/booking/domain/usecases/create_payment.dart';
import 'package:metro_mobile/features/booking/domain/usecases/get_fare_table.dart';
import 'package:metro_mobile/features/booking/domain/usecases/preview_order.dart';
import 'package:metro_mobile/features/booking/domain/usecases/watch_payment_status.dart';
import 'package:metro_mobile/features/network/network_providers.dart';

final bookingSourceProvider = Provider<BookingSource>(
  (ref) => BookingRemoteSource(
    ref.watch(dioProvider),
    catalog: ref.watch(networkRepositoryProvider).getCatalog,
  ),
);

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepositoryImpl(ref.watch(bookingSourceProvider)),
);

final previewOrderProvider = Provider(
  (ref) => PreviewOrder(ref.watch(bookingRepositoryProvider)),
);
final createPaymentProvider = Provider(
  (ref) => CreatePayment(ref.watch(bookingRepositoryProvider)),
);
final watchPaymentStatusProvider = Provider(
  (ref) => WatchPaymentStatus(ref.watch(bookingRepositoryProvider)),
);
final getFareTableProvider = Provider(
  (ref) => GetFareTable(ref.watch(bookingRepositoryProvider)),
);
