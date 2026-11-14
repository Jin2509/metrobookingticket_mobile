/// Nguồn gói tin thô vị trí tàu của một tuyến.
abstract interface class LiveTrainsSource {
  Stream<Object?> subscribe(String lineId);
  Stream<bool> get connection;
}
