import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/domain/repositories/incident_repository.dart';

typedef _Json = Map<String, Object?>;

/// Backend chưa có các endpoint này, đây là hợp đồng đề xuất.
class IncidentRemoteSource implements IncidentRepository {
  const IncidentRemoteSource(this._dio);
  final Dio _dio;

  static const _path = '/api/staff/incidents';

  static StationIncident _parse(_Json j) => StationIncident(
    id: '${j['id']}',
    stationName: j['stationName']! as String,
    type: IncidentType.parse(j['type'] as String?),
    location: IncidentLocation.parse(j['location'] as String?),
    severity: IncidentSeverity.parse(j['severity'] as String?),
    status: IncidentStatus.parse(j['status'] as String?),
    publication: IncidentPublication.parse(j['publication'] as String?),
    reporterName: j['reporterName'] as String? ?? '',
    createdAt: DateTime.parse(j['createdAt']! as String),
    description: j['description'] as String? ?? '',
    photoUrls: [for (final u in j['photoUrls'] as List? ?? const []) '$u'],
    history: [
      for (final h in j['history'] as List? ?? const [])
        IncidentEvent(
          status: IncidentStatus.parse((h as _Json)['status'] as String?),
          actorName: h['actorName'] as String? ?? '',
          at: DateTime.parse(h['at']! as String),
        ),
    ],
  );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<List<StationIncident>> getIncidents() => _guard(() async {
    final res = await _dio.get<List<dynamic>>(_path);
    return [for (final j in res.data ?? const <dynamic>[]) _parse(j as _Json)];
  });

  @override
  Future<StationIncident> submit(IncidentDraft d, String actorName) =>
      _guard(() async {
        final res = await _dio.post<_Json>(
          _path,
          data: FormData.fromMap({
            'type': d.type.code,
            'location': d.location.code,
            'severity': d.severity.code,
            'description': d.description,
            'proposeToPassengers': d.proposeToPassengers,
            'photos': [
              for (final (i, p) in d.photos.indexed)
                MultipartFile.fromBytes(
                  p,
                  filename: 'incident-$i.jpg',
                  contentType: DioMediaType('image', 'jpeg'),
                ),
            ],
          }),
        );
        return _parse(res.data!);
      });

  @override
  Future<StationIncident> updateStatus(
    String id,
    IncidentStatus status,
    String actorName,
  ) => _guard(() async {
    final res = await _dio.patch<_Json>(
      '$_path/$id/status',
      data: {'status': status.code},
    );
    return _parse(res.data!);
  });
}
