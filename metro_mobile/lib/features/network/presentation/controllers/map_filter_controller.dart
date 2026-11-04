import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bộ lọc bản đồ (UC5-01 A1): một tuyến hoặc tất cả, bật/tắt lớp buýt và lớp
/// độ đông.
@immutable
class MapFilter {
  const MapFilter({this.lineId, this.showBus = false, this.showCrowd = false});

  /// `null` = tất cả tuyến.
  final String? lineId;
  final bool showBus;
  final bool showCrowd;

  bool shows(String id) => lineId == null || lineId == id;
}

final mapFilterProvider =
    NotifierProvider.autoDispose<MapFilterController, MapFilter>(
      MapFilterController.new,
    );

class MapFilterController extends Notifier<MapFilter> {
  @override
  MapFilter build() => const MapFilter();

  void selectLine(String? lineId) => state = MapFilter(
    lineId: lineId,
    showBus: state.showBus,
    showCrowd: state.showCrowd,
  );

  void toggleBus() => state = MapFilter(
    lineId: state.lineId,
    showBus: !state.showBus,
    showCrowd: state.showCrowd,
  );

  void toggleCrowd() => state = MapFilter(
    lineId: state.lineId,
    showBus: state.showBus,
    showCrowd: !state.showCrowd,
  );
}
