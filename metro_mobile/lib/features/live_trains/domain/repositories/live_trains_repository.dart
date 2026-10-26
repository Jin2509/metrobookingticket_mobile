import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';

abstract interface class LiveTrainsRepository {
  /// Vị trí mới nhất của mọi tàu trên tuyến. Hủy listen = hủy subscribe.
  Stream<List<TrainPosition>> watchLine(String lineId);

  /// `true` đã kết nối, `false` đang kết nối lại.
  Stream<bool> get connection;
}
