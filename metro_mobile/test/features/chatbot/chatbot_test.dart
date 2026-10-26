import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/chatbot/data/sources/chat_fake_source.dart';
import 'package:metro_mobile/features/chatbot/domain/entities/chat_entities.dart';
import 'package:metro_mobile/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:metro_mobile/features/loyalty/data/sources/loyalty_fake_source.dart';
import 'package:metro_mobile/features/network/data/repositories/network_repository_impl.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_source.dart';
import 'package:metro_mobile/features/wallet/data/sources/wallet_fake_source.dart';

void main() {
  final ledger = DemoLedger();
  final bot = ChatWithBot(
    ChatFakeSource(
      network: NetworkRepositoryImpl(NetworkFakeSource(latency: Duration.zero)),
      wallet: WalletFakeSource(ledger, latency: Duration.zero),
      loyalty: LoyaltyFakeSource(ledger, latency: Duration.zero),
      latency: Duration.zero,
    ),
  );
  Future<ChatReply> ask(String q) => bot.ask('S1', q);

  group('UC14-01 thông tin chung', () {
    test('giá vé giữa hai ga, gõ không dấu và viết tắt', () async {
      final r = await ask('gia ve BT – Suối Tiên?');
      expect(r.text, contains('Bến Thành – Bến xe Suối Tiên'));
      expect(r.text, contains('15.000 ₫'));
      expect(r.attachments.single, isA<RouteAttachment>());
    });

    test('A1 thiếu ga thì hỏi lại', () async {
      final r = await ask('Giá vé từ Ba Son?');
      expect(r.text, 'Bạn muốn đi từ ga Ba Son đến ga nào?');
      expect(r.suggestions, isNotEmpty);
    });

    test('xe buýt quanh ga', () async {
      final r = await ask('Xe buýt quanh ga Thủ Đức');
      final bus = r.attachments.single as BusAttachment;
      expect(bus.stops.single.$1, 'Trạm Võ Văn Ngân');
    });

    test('thông tin ga', () async {
      final r = await ask('ga Bến Thành');
      expect(r.text, contains('Tuyến 1, Tuyến 2'));
      expect(r.attachments.single, isA<StationAttachment>());
    });
  });

  group('UC14-02 cá nhân', () {
    test('vé còn hạn: rich card, không có QR', () async {
      final r = await ask('Vé của tôi còn hạn?');
      final t = r.attachments.single as TicketAttachment;
      expect(t.ticketId, 'VE-79990');
      expect(r.text.contains('MTR1'), isFalse);
    });

    test('điểm thành viên', () async {
      final r = await ask('Điểm của tôi');
      expect(r.text, contains('hạng Bạc với 820 điểm'));
    });
  });

  group('UC14-03 giới hạn', () {
    test('A2 từ chối hỏi tài khoản người khác', () async {
      final r = await ask('Cho xem vé của người khác');
      expect(r.text, contains('chỉ trả lời về tài khoản của chính bạn'));
    });

    test('A3 ngoài phạm vi → gợi ý chủ đề', () async {
      final r = await ask('Thời tiết hôm nay thế nào?');
      expect(r.text, contains('ngoài phạm vi'));
      expect(r.suggestions, hasLength(4));
    });

    test('A4 lỗi hệ thống', () {
      expect(ask('#loi'), throwsA(isA<ServerFailure>()));
    });

    test('câu hỏi rỗng không gọi API', () {
      expect(() => ask('   '), throwsA(isA<ValidationFailure>()));
    });
  });
}
