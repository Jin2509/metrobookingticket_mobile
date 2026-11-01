import 'package:flutter_test/flutter_test.dart';

import 'app_flows.dart';

void main() {
  testWidgets('7.1 xác thực email rồi đăng nhập', verifyEmailThenLoginFlow);
  testWidgets('7.2 đặt vé 3 chạm', bookIn3TapsFlow);
  testWidgets('7.3 tra lộ trình → đặt vé', routeToBookingFlow);
  testWidgets('7.4 nhân viên check-in/out', staffCheckInOutFlow);
}
