import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/flows/app_flows.dart';

/// Chạy trên thiết bị: `flutter test integration_test`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('7.1 xác thực email rồi đăng nhập', verifyEmailThenLoginFlow);
  testWidgets('7.2 đặt vé 3 chạm', bookIn3TapsFlow);
  testWidgets('7.3 tra lộ trình → đặt vé', routeToBookingFlow);
  testWidgets('7.4 nhân viên check-in/out', staffCheckInOutFlow);
}
