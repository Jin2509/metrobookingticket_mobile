import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('còn vé hiệu lực thì không mua được vé mới', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/buy?type=DAY');
    c.read(ticketLimitBypassProvider.notifier).disable();
    await settle(tester);
    expect(find.text('Bạn vẫn còn vé hiệu lực'), findsOneWidget);
    final next = find.widgetWithText(MetroButton, 'Tiếp tục');
    expect(tester.widget<MetroButton>(next).onPressed, isNull);
    await unmount(tester, c);
  });
}
