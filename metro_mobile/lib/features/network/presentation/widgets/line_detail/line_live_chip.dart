import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/live_trains_controllers.dart';

/// Chip kết nối realtime, đọc trạng thái WebSocket.
class LineLiveChip extends ConsumerWidget {
  const LineLiveChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected =
        TickerMode.valuesOf(context).enabled &&
        (ref.watch(liveConnectionProvider).value ?? false);
    return LiveStatusChip(connected: connected);
  }
}
