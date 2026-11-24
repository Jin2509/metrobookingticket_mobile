// Contract test: gọi remote source THẬT của app vào backend đang chạy, kiểm tra
// DTO parse được dữ liệu thật (sai tên trường, sai kiểu, thiếu endpoint...).
//
// Không chạy trong `flutter test` mặc định (nằm ngoài thư mục test/).
// Chạy:
//   BACKEND_URL=http://localhost:8081 flutter test test_contract
// Backend cần nạp seed/metro-demo-seed.sql (tài khoản *.demo@metroticket.test).
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_remote_source.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_remote_source.dart';
import 'package:metro_mobile/features/chatbot/data/sources/chat_remote_source.dart';
import 'package:metro_mobile/features/forecast/data/sources/forecast_remote_source.dart';
import 'package:metro_mobile/features/loyalty/data/sources/loyalty_remote_source.dart';
import 'package:metro_mobile/features/network/data/sources/network_remote_source.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_remote_source.dart';
import 'package:metro_mobile/features/parking/data/sources/parking_remote_source.dart';
import 'package:metro_mobile/features/staff/incident/data/sources/incident_remote_source.dart';
import 'package:metro_mobile/features/staff/scan_history/data/sources/staff_scan_log.dart';
import 'package:metro_mobile/features/staff/shift/data/sources/shift_sources.dart';
import 'package:metro_mobile/features/student/data/sources/student_remote_source.dart';
import 'package:metro_mobile/features/wallet/data/sources/wallet_remote_source.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';

const _password = 'Doi-Mat-Khau-Nay@123';
final _base = Platform.environment['BACKEND_URL'];

Dio _dio([String? token]) => Dio(
  BaseOptions(
    baseUrl: _base ?? '',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    contentType: Headers.jsonContentType,
    headers: {'Authorization': ?(token == null ? null : 'Bearer $token')},
  ),
);

Future<String> _token(String email) async {
  final pair = await AuthRemoteSource(_dio()).login(email, _password);
  return pair.accessToken;
}

void main() {
  final skip = _base == null ? 'Đặt BACKEND_URL để chạy contract test' : null;
  late String passenger;
  late String staff;

  setUpAll(() async {
    if (skip != null) return;
    passenger = await _token('passenger.demo@metroticket.test');
    staff = await _token('staff.demo@metroticket.test');
  });

  group('Hành khách', skip: skip, () {
    test('mạng lưới: tuyến, ga, trung chuyển', () async {
      final c = await NetworkRemoteSource(_dio(passenger)).fetchCatalog();
      expect(c.lines, isNotEmpty);
      expect(c.stations, isNotEmpty);
    });

    test('chi tiết ga', () async {
      final src = NetworkRemoteSource(_dio(passenger));
      final c = await src.fetchCatalog();
      final d = await src.fetchStationDetail(c.stations.keys.first);
      expect(d, isNotNull);
    });

    test('bảng giá vé', () async {
      final net = NetworkRemoteSource(_dio(passenger));
      final t = await BookingRemoteSource(
        _dio(passenger),
        catalog: net.fetchCatalog,
      ).fetchFareTable();
      expect(t, isNotNull);
    });

    test('ví: vé của tôi, giao dịch, gửi xe', () async {
      final w = WalletRemoteSource(_dio(passenger));
      final tickets = await w.getMyTickets(TicketFilter.all, 0, 20);
      expect(tickets.items, isNotEmpty, reason: 'seed có vé cho passenger');
      await w.getTicket(tickets.items.first.id);
      await w.getTransactions(0, 20);
      await w.getActiveParking();
      await w.getParkingHistory();
    });

    test('CPoint / hạng thành viên', () async {
      final l = LoyaltyRemoteSource(_dio(passenger));
      await l.getSummary();
      await l.getPointsHistory();
    });

    test('bãi gửi xe', () async {
      final lots = await ParkingRemoteSource(_dio(passenger)).getLots();
      expect(lots, isNotEmpty);
    });

    test('thông báo, tin tức, cài đặt thông báo', () async {
      final n = NotificationRemoteSource(_dio(passenger));
      await n.getNotifications();
      await n.getNews();
      await n.getPrefs();
    });

    test('trạng thái sinh viên', () async {
      await StudentRemoteSource(_dio(passenger)).getMine();
    });

    test('dự báo đông khách theo ga (forecast)', () async {
      final f = ForecastRemoteSource(_dio(passenger));
      await f.getNetworkCrowd(DateTime.now());
    });

    test('chatbot: mở phiên (không gửi câu hỏi để tránh gọi AI tốn phí)', () async {
      final (session, reply) = await ChatRemoteSource(
        _dio(passenger),
      ).startSession();
      expect(reply.text, isNotEmpty);
      expect(session, isNotNull);
    });
  });

  group('Nhân viên', skip: skip, () {
    test('ca trực: ga được phân công', () async {
      final s = await ShiftRemoteSource(_dio(staff), StaffScanLog()).getShift();
      expect(s, isNotNull);
    });

    test('sự cố của tôi', () async {
      await IncidentRemoteSource(
        _dio(staff),
        stationId: () async => '1',
      ).getIncidents();
    });
  });
}
