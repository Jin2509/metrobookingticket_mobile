import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/test_app.dart';

/// Đo khung hình bản đồ có tàu realtime trên thiết bị thật (profile):
/// `flutter drive --profile --driver=test_driver/integration_test.dart
///  --target=integration_test/map_performance_test.dart`.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('bản đồ + tàu realtime 10s', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore/map');
    await binding.watchPerformance(() async {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
    }, reportKey: 'map_live_trains');
    await unmount(tester, c);
  });
}
