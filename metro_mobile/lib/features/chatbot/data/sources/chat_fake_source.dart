import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/core/utils/vn_text.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';
import 'package:metro_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:metro_mobile/features/loyalty/domain/repositories/loyalty_repository.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/repositories/wallet_repository.dart';

/// Trợ lý demo theo luật (giống `src/lib/chatbot.ts` của web), dữ liệu
/// thật từ các repository: mạng lưới, vé của tôi, thành viên.
/// Gõ `#loi` để thử nhánh lỗi A4.
class ChatFakeSource implements ChatRepository {
  ChatFakeSource({
    required NetworkRepository network,
    required WalletRepository wallet,
    required LoyaltyRepository loyalty,
    this.latency = const Duration(milliseconds: 500),
  }) : _network = network,
       _wallet = wallet,
       _loyalty = loyalty;

  final NetworkRepository _network;
  final WalletRepository _wallet;
  final LoyaltyRepository _loyalty;
  final Duration latency;
  final feedback = <String, MessageFeedback>{};
  int _seq = 0;

  static const suggestions = [
    'Giá vé BT – Suối Tiên?',
    'Xe buýt quanh ga Thủ Đức',
    'Vé của tôi còn hạn?',
    'Điểm của tôi',
  ];

  ChatReply _reply(
    String text, {
    List<ChatAttachment> attachments = const [],
    List<String> suggest = const [],
  }) => ChatReply(
    messageId: 'M${++_seq}',
    text: text,
    attachments: attachments,
    suggestions: suggest,
  );

  @override
  Future<(String, ChatReply)> startSession() async {
    await Future<void>.delayed(latency);
    return (
      'S${DateTime.now().millisecondsSinceEpoch}',
      _reply(
        'Chào bạn! Mình có thể giúp tra giá vé, lộ trình, ga, xe buýt '
        'quanh ga, vé và điểm của bạn.',
        suggest: suggestions,
      ),
    );
  }

  @override
  Future<void> sendFeedback(String id, MessageFeedback f) async =>
      feedback[id] = f;

  bool _has(String q, List<String> keys) => keys.any(q.contains);

  /// Tên đầy đủ, mã ga, và 2 từ cuối với tên dài (`Bến xe Suối Tiên` →
  /// `suoi tien`) vì người dùng hay gọi tắt.
  List<String> _keys(Station s) {
    final name = normalizeVn(s.name);
    final words = name.split(' ');
    return [
      name,
      if (words.length >= 3) words.sublist(words.length - 2).join(' '),
      s.id.toLowerCase(),
    ];
  }

  /// Ga được nhắc tới theo thứ tự xuất hiện; tên dài khớp trước.
  List<Station> _stations(String q, NetworkCatalog c) {
    final found = <(int, Station)>[];
    final all = [...c.stations.values]
      ..sort((a, b) => b.name.length.compareTo(a.name.length));
    var rest = ' $q ';
    for (final s in all) {
      for (final key in _keys(s)) {
        final i = rest.indexOf(RegExp('[^a-z0-9]$key[^a-z0-9]'));
        if (i < 0) continue;
        found.add((i, s));
        rest = rest.replaceRange(i + 1, i + 1 + key.length, '#' * key.length);
        break;
      }
    }
    found.sort((a, b) => a.$1.compareTo(b.$1));
    return [for (final f in found) f.$2];
  }

  @override
  Future<ChatReply> ask(String token, String question) async {
    await Future<void>.delayed(latency);
    final q = normalizeVn(question);
    if (q.contains('#loi')) throw const ServerFailure();
    if (_has(q, ['nguoi khac', 'tai khoan khac', 'cua ban toi', 'cua vo'])) {
      return _reply('Vì bảo mật, mình chỉ trả lời về tài khoản của chính bạn.');
    }
    final catalog = await _network.getCatalog();
    final stations = _stations(q, catalog);
    if (_has(q, [
      'gia',
      'bao nhieu tien',
      'lo trinh',
      'di tu',
      'mat bao lau',
    ])) {
      return await _route(stations);
    }
    if (_has(q, ['buyt', 'bus'])) return await _bus(stations);
    if (_has(q, ['ve cua toi', 'con han', 'het han', 've thang'])) {
      return await _tickets();
    }
    if (_has(q, ['diem', 'hang thanh vien', 'uu dai'])) {
      return await _points();
    }
    if (stations.isNotEmpty) return _station(stations.first, catalog);
    if (_has(q, ['xin chao', 'chao', 'hello'])) {
      return _reply('Chào bạn! Bạn cần mình hỗ trợ gì?', suggest: suggestions);
    }
    return _reply(
      'Câu hỏi này nằm ngoài phạm vi của mình. Bạn có thể hỏi về:',
      suggest: suggestions,
    );
  }

  Future<ChatReply> _route(List<Station> s) async {
    if (s.length < 2) {
      return _reply(
        s.isEmpty
            ? 'Bạn muốn đi từ ga nào đến ga nào?'
            : 'Bạn muốn đi từ ga ${s.first.name} đến ga nào?',
        suggest: const ['Bến Thành đến Suối Tiên', 'Ba Son đến Thủ Đức'],
      );
    }
    final (from, to) = (s[0], s[1]);
    if (!from.active || !to.active) {
      return _reply('Ga ${(from.active ? to : from).name} chưa hoạt động.');
    }
    final plan = await _network.searchRoute(from.id, to.id);
    return _reply(
      'Vé lượt ${from.name} – ${to.name}: ${money(plan.fare)} '
      '(${plan.stationCount} ga, khoảng ${plan.minutes} phút).',
      attachments: [RouteAttachment(fromId: from.id, toId: to.id)],
    );
  }

  Future<ChatReply> _bus(List<Station> s) async {
    if (s.isEmpty) {
      return _reply(
        'Bạn muốn xem xe buýt quanh ga nào?',
        suggest: const ['Xe buýt quanh ga Bến Thành'],
      );
    }
    final d = await _network.getStationDetail(s.first.id);
    if (d.busStops.isEmpty) {
      return _reply('Ga ${s.first.name} chưa có trạm buýt kết nối.');
    }
    return _reply(
      'Quanh ga ${s.first.name} có ${d.busStops.length} trạm buýt:',
      attachments: [
        BusAttachment(stops: [for (final b in d.busStops) (b.name, b.routes)]),
      ],
    );
  }

  Future<ChatReply> _tickets() async {
    final page = await _wallet.getMyTickets(TicketFilter.unused, 0, 5);
    if (page.items.isEmpty) return _reply('Bạn chưa có vé còn hiệu lực.');
    final t = page.items.first;
    return _reply(
      'Bạn có ${page.items.length} vé chưa sử dụng. Vé gần nhất:',
      attachments: [
        TicketAttachment(
          ticketId: t.id,
          title: t.typeName,
          validUntil: t.validUntil,
        ),
      ],
    );
  }

  Future<ChatReply> _points() async {
    final m = await _loyalty.getSummary();
    final next = m.nextTierName == null
        ? '.'
        : ', còn ${count(m.pointsToNext)} điểm lên ${m.nextTierName}.';
    return _reply(
      'Bạn đang ở hạng ${m.tierName} với ${count(m.points)} điểm$next',
    );
  }

  ChatReply _station(Station s, NetworkCatalog c) => _reply(
    'Ga ${s.name} (${s.structureLabel}) thuộc '
    '${c.linesOf(s).map((l) => l.code).join(', ')}'
    '${s.active ? '' : ', hiện chưa khai thác'}.',
    attachments: [StationAttachment(stationId: s.id, name: s.name)],
  );
}
