import 'dart:async';

typedef Record = Map<String, Object?>;

/// Bộ nhớ dùng chung của các Fake source (vé, đơn, giao dịch, gửi xe),
/// để luồng đặt vé → vé của tôi → soát vé chạy được khi chưa có backend.
/// Bản ghi là JSON thô; mỗi feature tự parse bằng DTO của mình.
class DemoLedger {
  DemoLedger({DateTime Function()? clock}) : clock = clock ?? DateTime.now {
    _seed();
  }

  final DateTime Function() clock;

  /// Mới nhất ở đầu danh sách.
  final tickets = <Record>[];
  final transactions = <Record>[];
  final parking = <Record>[];
  final orders = <String, Record>{};
  final notifications = <Record>[];

  /// Bộ QR mẫu cho nhân viên (kịch bản 12.1, phương án dự phòng): không
  /// thuộc "Vé của tôi" của hành khách demo.
  final sampleTickets = <Record>[];
  final sampleParking = <Record>[];

  /// Nhật ký soát vé / gửi xe trong ca (`ticket_usage_history`).
  final scanLog = <Record>[];

  /// Vé theo mã (`VE-…`) hoặc token QR, gồm cả vé mẫu.
  Record? findTicket(String codeOrToken) {
    final key = codeOrToken.trim().toUpperCase();
    for (final t in [...tickets, ...sampleTickets]) {
      if ((t['code']! as String).toUpperCase() == key ||
          (t['qrToken']! as String).toUpperCase() == key) {
        return t;
      }
    }
    return null;
  }

  Record? findParking(String token) {
    for (final p in [...parking, ...sampleParking]) {
      if (p['qrToken'] == token || p['id'] == token) return p;
    }
    return null;
  }

  /// Thông báo mới (giả lập WS `/user/queue/notifications`).
  final _events = StreamController<Record>.broadcast();
  Stream<Record> get notificationEvents => _events.stream;

  void notify(String kind, String title, {String? body, String? link}) {
    final n = <String, Object?>{
      'id': 'TB-${_seq++}',
      'kind': kind,
      'title': title,
      'body': body,
      'link': link,
      'read': false,
      'createdAt': clock().toUtc().toIso8601String(),
    };
    notifications.insert(0, n);
    _events.add(n);
  }

  int _seq = 80021;

  String nextCode() => '${_seq++}';

  void _seed() {
    final now = clock().toUtc();
    String iso(Duration d) => now.add(d).toIso8601String();
    tickets.add({
      'id': 'VE-79990',
      'code': 'VE-79990',
      'typeCode': 'MONTH_STUDENT',
      'typeName': 'Vé tháng HSSV',
      'status': 'PAID',
      'price': 150000,
      'validFrom': iso(const Duration(days: -7)),
      'validUntil': iso(const Duration(days: 30)),
      'purchasedAt': iso(const Duration(days: -7)),
      'qrToken': 'tk_79990m',
    });
    const route = [
      ('BT', 'Bến Thành'),
      ('TD', 'Thủ Đức'),
      ('BS', 'Ba Son'),
      ('AP', 'An Phú'),
      ('ST', 'Bến xe Suối Tiên'),
      ('VT', 'Văn Thánh'),
    ];
    for (var i = 0; i < 24; i++) {
      final (fromId, fromName) = route[i % route.length];
      final (toId, toName) = route[(i + 1) % route.length];
      final day = Duration(days: -(i + 1));
      tickets.add({
        'id': 'VE-${79960 - i}',
        'code': 'VE-${79960 - i}',
        'typeCode': 'SINGLE',
        'typeName': 'Vé lượt',
        'status': i == 3 ? 'EXPIRED' : 'USED',
        'price': 12000,
        'fromId': fromId,
        'fromName': fromName,
        'toId': toId,
        'toName': toName,
        'validFrom': iso(day),
        'validUntil': iso(day + const Duration(hours: 18)),
        'purchasedAt': iso(day),
        'qrToken': 'tk_${79960 - i}s',
      });
    }
    for (final t in tickets) {
      transactions.add({
        'id': 'GD-${t['id']}',
        'orderCode': 'DH${(t['id']! as String).substring(3)}',
        'title': t['typeName'],
        'amount': t['price'],
        'method': 'QR',
        'status': 'SUCCESS',
        'createdAt': t['purchasedAt'],
      });
    }
    transactions.insert(1, {
      'id': 'GD-F1',
      'orderCode': 'DH79970',
      'title': 'Vé ngày',
      'amount': 40000,
      'method': 'QR',
      'status': 'FAILED',
      'createdAt': iso(const Duration(days: -2)),
    });
    notifications.addAll([
      {
        'id': 'TB-3',
        'kind': 'TICKET_EXPIRY',
        'title': 'Vé tháng còn 30 ngày',
        'body': 'Vé tháng HSSV hết hạn sau 30 ngày.',
        'read': false,
        'link': '/p/tickets/VE-79990',
        'createdAt': iso(const Duration(hours: -3)),
      },
      {
        'id': 'TB-2',
        'kind': 'SUGGESTION',
        'title': 'Gợi ý: mua vé tháng tiết kiệm hơn',
        'body': 'Bạn đi 24 lượt tháng này, vé tháng rẻ hơn 15%.',
        'read': true,
        'link': '/p/fares',
        'createdAt': iso(const Duration(days: -1)),
      },
      {
        'id': 'TB-1',
        'kind': 'OPERATION',
        'title': 'Tuyến 1 chạy chậm 10 phút',
        'body': 'Do kiểm tra kỹ thuật đoạn Văn Thánh – Tân Cảng.',
        'read': true,
        'createdAt': iso(const Duration(days: -4)),
      },
    ]);
    _seedStaffSamples(now);
    parking.add({
      'id': 'GX-1024',
      'lotName': 'Bãi PK1 · Suối Tiên',
      'plate': '59X1-234.56',
      'vehicle': 'MOTORBIKE',
      'status': 'DANG_GUI',
      'since': iso(const Duration(hours: -2)),
      'validUntil': iso(const Duration(hours: 10)),
      'qrToken': 'pk_1024',
    });
  }

  void _seedStaffSamples(DateTime now) {
    String iso(Duration d) => now.add(d).toIso8601String();
    Record ticket(
      String n,
      String status,
      String to,
      String toName,
      Duration validFor,
    ) => {
      'id': 'VE-MAU-$n',
      'code': 'VE-MAU-$n',
      'typeCode': 'SINGLE',
      'typeName': 'Vé lượt',
      'status': status,
      'price': 12000,
      'fromId': 'BT',
      'fromName': 'Bến Thành',
      'toId': to,
      'toName': toName,
      'validFrom': iso(const Duration(hours: -2)),
      'validUntil': iso(validFor),
      'purchasedAt': iso(const Duration(hours: -2)),
      'qrToken': 'tk_mau$n',
    };
    sampleTickets.addAll([
      ticket('01', 'PAID', 'TD', 'Thủ Đức', const Duration(hours: 12)),
      ticket('02', 'USED', 'TD', 'Thủ Đức', const Duration(hours: 12)),
      ticket('03', 'PAID', 'TD', 'Thủ Đức', const Duration(hours: -1)),
      ticket('04', 'IN_USE', 'AP', 'An Phú', const Duration(hours: 12)),
    ]);
    sampleParking.addAll([
      {
        'id': 'GX-MAU-1',
        'lotName': 'Bãi PK2 · Thủ Đức',
        'plate': '51G-888.88',
        'vehicle': 'CAR',
        'status': 'CHUA_GUI',
        'validUntil': iso(const Duration(hours: 10)),
        'qrToken': 'pk_mau1',
      },
      {
        'id': 'GX-MAU-2',
        'lotName': 'Bãi PK2 · Thủ Đức',
        'plate': '59X2-111.22',
        'vehicle': 'MOTORBIKE',
        'status': 'DANG_GUI',
        'since': iso(const Duration(hours: -3)),
        'validUntil': iso(const Duration(hours: 9)),
        'qrToken': 'pk_mau2',
      },
    ]);
  }
}
