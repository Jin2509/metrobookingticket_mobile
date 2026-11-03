import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hai ngăn của sheet trên bản đồ.
enum MapPanel { nearby, places }

@immutable
class MapPanelState {
  const MapPanelState({this.panel = MapPanel.nearby, this.stationId});

  final MapPanel panel;

  /// Ga đang xem ở ngăn Quanh ga, cũng là ga được đánh dấu trên bản đồ.
  final String? stationId;
}

final mapPanelProvider =
    NotifierProvider.autoDispose<MapPanelController, MapPanelState>(
      MapPanelController.new,
    );

class MapPanelController extends Notifier<MapPanelState> {
  @override
  MapPanelState build() => const MapPanelState();

  void show(MapPanel panel) =>
      state = MapPanelState(panel: panel, stationId: state.stationId);

  /// Chọn ga (chạm trên bản đồ hoặc bộ chọn) thì mở Quanh ga của ga đó.
  void selectStation(String id) =>
      state = MapPanelState(panel: MapPanel.places, stationId: id);
}
