import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/data/sources/incident_fake_source.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';

import '../../helpers/test_app.dart';

const _draft = IncidentDraft(
  type: IncidentType.gate,
  location: IncidentLocation.exitGate,
  severity: IncidentSeverity.operations,
  description: 'Mô tả nội bộ',
  proposeToPassengers: true,
);

void main() {
  test('đề xuất được duyệt thì có thông báo, không lộ mô tả nội bộ', () async {
    final ledger = DemoLedger();
    final source = IncidentFakeSource(ledger, approvalDelay: Duration.zero);
    await source.submit(_draft, 'Nhân viên A');
    final list = await source.getIncidents();
    expect(list.first.publication, IncidentPublication.published);
    expect(list.first.status, IncidentStatus.open);
    final notice = ledger.operationalNews.single;
    expect(notice['title'], contains('Ga Thủ Đức'));
    expect(notice.values.join(), isNot(contains('Mô tả nội bộ')));
  });

  test('không đề xuất thì không có thông báo', () async {
    final ledger = DemoLedger();
    final source = IncidentFakeSource(ledger, approvalDelay: Duration.zero);
    await source.submit(
      const IncidentDraft(
        type: IncidentType.hygiene,
        location: IncidentLocation.platform,
        severity: IncidentSeverity.minor,
      ),
      'Nhân viên A',
    );
    expect(ledger.operationalNews, isEmpty);
  });

  test('xử lý xong thì gỡ thông báo và ghi người đổi', () async {
    final ledger = DemoLedger();
    final source = IncidentFakeSource(ledger, approvalDelay: Duration.zero);
    final e = await source.submit(_draft, 'Nhân viên A');
    final done = await source.updateStatus(
      e.id,
      IncidentStatus.resolved,
      'Nhân viên B',
    );
    expect(done.history.single.actorName, 'Nhân viên B');
    expect(ledger.operationalNews, isEmpty);
  });

  testWidgets('báo sự cố từ màn soát vé rồi xử lý xong', (tester) async {
    final c = await pumpStaffAt(tester, '/s/scan');
    await tester.tap(find.byTooltip('Sự cố tại ga'));
    await settle(tester);
    expect(find.textContaining('Thang cuốn, thang máy'), findsOneWidget);

    await tester.tap(find.text('Báo sự cố'));
    await settle(tester);
    final send = find.widgetWithText(MetroButton, 'Gửi báo cáo');
    await tester.ensureVisible(send);
    expect(tester.widget<MetroButton>(send).onPressed, isNull);

    await tester.tap(find.text('Cổng soát vé'));
    await tester.pump();
    await tester.tap(find.text('Cổng ra'));
    await tester.pump();
    await tester.tap(find.text('Ảnh hưởng vận hành'));
    await tester.pump();
    await tester.ensureVisible(send);
    await tester.pump();
    await tester.tap(send);
    await settle(tester);
    await tester.pump(const Duration(seconds: 4));

    final tile = find.textContaining('Cổng soát vé · Cổng ra');
    expect(tile, findsOneWidget);
    await tester.tap(tile);
    await settle(tester);
    expect(
      find.text('Đã được duyệt, đang hiện cho hành khách'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(MetroButton, 'Đã xử lý'));
    await settle(tester);
    expect(find.widgetWithText(MetroButton, 'Đã xử lý'), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
    await unmount(tester, c);
  });
}
