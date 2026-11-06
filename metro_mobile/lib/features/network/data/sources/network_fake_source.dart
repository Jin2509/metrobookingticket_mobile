import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/geo.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_data.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_places.dart';
import 'package:metro_mobile/features/network/data/sources/network_source.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Mạng lưới demo offline khi BASE_URL rỗng.
class NetworkFakeSource implements NetworkSource {
  NetworkFakeSource({this.latency = const Duration(milliseconds: 400)});

  final Duration latency;
  final _catalog = NetworkCatalog(
    lines: NetworkFakeData.lines,
    stations: NetworkFakeData.stations,
  );

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<NetworkCatalog> fetchCatalog() async {
    await _wait();
    return _catalog;
  }

  @override
  Future<StationDetail> fetchStationDetail(String id) async {
    await _wait();
    final s = _catalog.station(id);
    if (s == null) throw const NotFoundFailure('Không tìm thấy ga');
    return StationDetail(
      station: s,
      amenities: NetworkFakePlaces.amenities[id] ?? const [],
      busStops: NetworkFakePlaces.busStops[id] ?? const [],
      exits: NetworkFakePlaces.exits[id] ?? const [],
    );
  }

  @override
  Future<List<NearbyStation>> fetchNearest(double lat, double lng) async {
    await _wait();
    return [
      for (final s in NetworkFakeData.stations)
        if (s.active)
          NearbyStation(
            station: s,
            distanceM: distanceMeters(lat, lng, s.lat, s.lng),
          ),
    ];
  }

  @override
  Future<List<BusStop>> fetchBusStops() async {
    await _wait();
    return [for (final l in NetworkFakePlaces.busStops.values) ...l];
  }
}
