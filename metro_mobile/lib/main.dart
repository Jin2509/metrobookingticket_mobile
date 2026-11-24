import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:metro_mobile/app/app.dart';
import 'package:metro_mobile/app/missing_config_app.dart';
import 'package:metro_mobile/core/config/env.dart';

/// Entry point chung cho cả Passenger và Staff (P1).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Env.baseUrl.isEmpty) {
    runApp(const MissingConfigApp());
    return;
  }
  await initializeDateFormatting('vi_VN');
  runApp(const ProviderScope(child: MetroApp()));
}
