import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bộ lọc bản đồ (UC5-01 A1): một tuyến hoặc tất cả, bật/tắt lớp buýt.
@immutable
class MapFilter {
  const MapFilter({this.lineId, this.showBus = false});

  /// `null` = tất cả tuyến.
  final String? lineId;
  final bool showBus;

  bool shows(String id) => lineId == null || lineId == id;
}

final mapFilterProvider =
    NotifierProvider.autoDispose<MapFilterController, MapFilter>(
      MapFilterController.new,
    );

class MapFilterController extends Notifier<MapFilter> {
  @override
  MapFilter build() => const MapFilter();

  void selectLine(String? lineId) =>
      state = MapFilter(lineId: lineId, showBus: state.showBus);

  void toggleBus() =>
      state = MapFilter(lineId: state.lineId, showBus: !state.showBus);
}
