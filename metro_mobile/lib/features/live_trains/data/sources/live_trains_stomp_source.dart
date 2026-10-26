import 'package:metro_mobile/core/network/stomp_client.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_source.dart';

class LiveTrainsStompSource implements LiveTrainsSource {
  const LiveTrainsStompSource(this._client);
  final MetroStompClient _client;

  @override
  Stream<Object?> subscribe(String lineId) =>
      _client.subscribe('/topic/trains/$lineId');

  @override
  Stream<bool> get connection => _client.connection;
}
