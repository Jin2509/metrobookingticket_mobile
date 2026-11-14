import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';

/// Loại vé, bậc giá, ưu đãi demo (bản thật lấy từ backend).
abstract final class BookingFakeCatalog {
  static const single = 'SINGLE';
  static const monthStudent = 'MONTH_STUDENT';

  static const fareTable = FareTable(
    types: [
      TicketType(code: single, name: 'Vé lượt', validity: 'Trong ngày'),
      TicketType(
        code: 'DAY',
        name: 'Vé ngày',
        validity: 'Trong ngày',
        price: 40000,
      ),
      TicketType(
        code: 'THREE_DAY',
        name: 'Vé 3 ngày',
        validity: '72 giờ',
        price: 90000,
      ),
      TicketType(
        code: 'MONTH',
        name: 'Vé tháng',
        validity: '30 ngày',
        price: 300000,
      ),
      TicketType(
        code: monthStudent,
        name: 'Vé tháng HSSV',
        validity: '30 ngày',
        price: 150000,
      ),
    ],
    singleTiers: [
      FareTier(maxStations: 3, price: 7000),
      FareTier(maxStations: 6, price: 9000),
      FareTier(maxStations: 9, price: 11000),
      FareTier(maxStations: 12, price: 12000),
      FareTier(price: 15000),
    ],
  );

  static const promoLabel = 'Ưu đãi "SV Tháng 11"';
  static const promoPercent = 20;
  static const tierLabel = 'Cây xanh · 635 CPoint (-5%)';
  static const tierPercent = 5;

  /// Tài khoản nhận demo (không phải tài khoản thật, không chuyển tiền).
  static const bank = {
    'bin': '970422',
    'name': 'MB Bank',
    'accountNumber': 'VQRDEMO0001',
    'accountName': 'METRO HCMC DEMO',
  };

  static TicketType type(String code) =>
      fareTable.types.firstWhere((t) => t.code == code);
}
