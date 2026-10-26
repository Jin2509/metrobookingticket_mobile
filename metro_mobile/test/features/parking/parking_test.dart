import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_fake_source.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/network/data/repositories/network_repository_impl.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_source.dart';
import 'package:metro_mobile/features/parking/data/sources/parking_fake_source.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/usecases/parking_usecases.dart';

ParkingRequest _req({
  String lot = 'PK2-TD',
  String vehicle = 'MOTORBIKE',
  String plate = '51G-888.88',
  ParkingPackage pkg = ParkingPackage.turn,
}) => ParkingRequest(lotId: lot, vehicle: vehicle, plate: plate, package: pkg);

void main() {
  late DemoLedger ledger;
  late ParkingFakeSource repo;
  setUp(() {
    ledger = DemoLedger();
    repo = ParkingFakeSource(ledger, latency: Duration.zero);
  });

  test('A1: biển số Việt Nam', () {
    for (final ok in ['59X1-234.56', '51G-888.88', '51G-88888', '59X123456']) {
      expect(validatePlate('MOTORBIKE', ok), isNull, reason: ok);
    }
    for (final bad in ['', 'ABC', '5G-123.45', '59X1-23']) {
      expect(validatePlate('CAR', bad), isNotNull, reason: bad);
    }
    expect(validatePlate('BICYCLE', ''), isNull);
    expect(
      () => PreviewParking(repo)(_req(plate: 'sai')),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('phí theo loại xe × gói', () async {
    expect((await repo.preview(_req())).fee, 5000);
    final month = await repo.preview(
      _req(vehicle: 'CAR', pkg: ParkingPackage.month),
    );
    expect(month.fee, 1200000);
    expect(month.validHours, 720);
  });

  test('A4: biển số đang có lượt gửi còn hiệu lực', () async {
    final p = await repo.preview(_req(plate: '59x1-23456'));
    expect(p.activePassId, 'GX-1024');
    expect(
      CreateParkingPayment(repo)(_req(plate: '59X1-234.56')),
      throwsA(isA<ConflictFailure>()),
    );
  });

  test('A3: ô tô ở Suối Tiên hết chỗ', () {
    expect(
      CreateParkingPayment(repo)(_req(lot: 'PK1-ST', vehicle: 'CAR')),
      throwsA(
        isA<ConflictFailure>().having(
          (f) => f.message,
          'message',
          'Loại giữ xe đã hết chỗ',
        ),
      ),
    );
  });

  test('thanh toán gửi xe → tạo lượt gửi xe + thông báo', () {
    fakeAsync((async) {
      final payments = BookingRepositoryImpl(
        BookingFakeSource(
          ledger: ledger,
          network: NetworkRepositoryImpl(
            NetworkFakeSource(latency: Duration.zero),
          ),
          latency: Duration.zero,
        ),
      );
      PaymentUpdate? last;
      unawaited(
        CreateParkingPayment(repo)(
          _req(),
        ).then((id) => payments.watchPaymentStatus(id).listen((u) => last = u)),
      );
      async.elapse(const Duration(seconds: 4));
      expect(last!.status, PaymentStatus.success);
      expect(last!.parkingId, startsWith('GX-'));
      expect(ledger.parking.first['plate'], '51G-888.88');
      expect(ledger.parking.first['status'], 'CHUA_GUI');
      expect(ledger.notifications.first['title'], 'Đăng ký gửi xe thành công');
    });
  });
}
