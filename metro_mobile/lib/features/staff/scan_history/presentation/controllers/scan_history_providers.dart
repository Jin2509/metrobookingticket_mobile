import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/usecases/get_scan_history.dart';
import 'package:metro_mobile/features/staff/staff_providers.dart';

final scanHistoryProvider = FutureProvider.autoDispose
    .family<List<ScanLogEntry>, ScanLogFilter>(
      (ref, f) => GetScanHistory(ref.watch(scanHistoryRepositoryProvider))(f),
    );
