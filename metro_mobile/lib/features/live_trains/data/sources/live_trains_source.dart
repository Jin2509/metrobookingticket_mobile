/// Nguồn gói tin thô của `/topic/trains/{lineId}`.
abstract interface class LiveTrainsSource {
  Stream<Object?> subscribe(String lineId);
  Stream<bool> get connection;
}
