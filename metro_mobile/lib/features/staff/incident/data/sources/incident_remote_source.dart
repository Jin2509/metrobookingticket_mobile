import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/domain/repositories/incident_repository.dart';

typedef _Json = Map<String, Object?>;

/// `POST /api/v1/incidents` (multipart `data` + `image`), danh sách của tôi
/// `/me/incidents`, nhận/xử lý `/incidents/{id}/accept|resolve`.
///
/// Backend có ít loại/mức độ hơn app và không có vị trí, đề xuất thông báo:
/// vị trí được ghi ở dòng đầu mô tả; chỉ gửi ảnh đầu tiên.
class IncidentRemoteSource implements IncidentRepository {
  const IncidentRemoteSource(this._dio, {required this.stationId});
  final Dio _dio;

  /// Ga đang phân công của nhân viên.
  final Future<String> Function() stationId;

  static const _base = '/api/v1';

  static const _locLabels = {
    IncidentLocation.entryGate: 'Cổng vào',
    IncidentLocation.exitGate: 'Cổng ra',
    IncidentLocation.concourse: 'Sảnh',
    IncidentLocation.platform: 'Sân ga',
    IncidentLocation.parking: 'Bãi xe',
    IncidentLocation.other: 'Nơi khác',
  };
  static const _locPrefix = 'Vị trí: ';

  static String _type(IncidentType t) => switch (t) {
    IncidentType.security => 'SECURITY',
    IncidentType.medical => 'MEDICAL',
    IncidentType.hygiene || IncidentType.other => 'OTHER',
    _ => 'EQUIPMENT',
  };

  static String _severity(IncidentSeverity s) => switch (s) {
    IncidentSeverity.minor => 'LOW',
    IncidentSeverity.operations => 'HIGH',
    IncidentSeverity.emergency => 'CRITICAL',
  };

  static IncidentSeverity _parseSeverity(Object? s) => switch (s) {
    'LOW' => IncidentSeverity.minor,
    'CRITICAL' => IncidentSeverity.emergency,
    _ => IncidentSeverity.operations,
  };

  static StationIncident _parse(_Json j) {
    var text = j['description'] as String? ?? '';
    var location = IncidentLocation.other;
    if (text.startsWith(_locPrefix)) {
      final end = text.indexOf('\n');
      final label = text.substring(
        _locPrefix.length,
        end < 0 ? text.length : end,
      );
      location =
          _locLabels.entries
              .where((e) => e.value == label.trim())
              .firstOrNull
              ?.key ??
          IncidentLocation.other;
      text = end < 0 ? '' : text.substring(end + 1).trimLeft();
    }
    DateTime? at(String k) =>
        j[k] == null ? null : DateTime.parse(j[k]! as String);
    final created = at('createdAt')!;
    return StationIncident(
      id: '${j['id']}',
      stationName: j['stationName'] as String? ?? '',
      type: IncidentType.parse(j['type'] as String?),
      location: location,
      severity: _parseSeverity(j['severity']),
      status: switch (j['status']) {
        'IN_PROGRESS' => IncidentStatus.inProgress,
        'RESOLVED' => IncidentStatus.resolved,
        _ => IncidentStatus.open,
      },
      publication: IncidentPublication.none,
      reporterName: '',
      createdAt: created,
      description: text,
      history: [
        IncidentEvent(status: IncidentStatus.open, actorName: '', at: created),
        if (at('acceptedAt') case final a?)
          IncidentEvent(
            status: IncidentStatus.inProgress,
            actorName: '',
            at: a,
          ),
        if (at('resolvedAt') case final r?)
          IncidentEvent(status: IncidentStatus.resolved, actorName: '', at: r),
      ],
    );
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<List<StationIncident>> getIncidents() => _guard(() async {
    final res = await _dio.get<_Json>(
      '$_base/me/incidents',
      queryParameters: {'size': 50},
    );
    return [
      for (final j in res.data?['content'] as List? ?? const [])
        _parse(j as _Json),
    ];
  });

  @override
  Future<StationIncident> submit(IncidentDraft d, String actorName) =>
      _guard(() async {
        final data = {
          'stationId': int.parse(await stationId()),
          'type': _type(d.type),
          'severity': _severity(d.severity),
          'description':
              '$_locPrefix${_locLabels[d.location]}\n\n${d.description}'.trim(),
        };
        final res = await _dio.post<_Json>(
          '$_base/incidents',
          data: FormData.fromMap({
            'data': MultipartFile.fromString(
              jsonEncode(data),
              contentType: DioMediaType('application', 'json'),
            ),
            if (d.photos.firstOrNull case final p?)
              'image': MultipartFile.fromBytes(
                p,
                filename: 'incident.jpg',
                contentType: DioMediaType('image', 'jpeg'),
              ),
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
    final res = status == IncidentStatus.resolved
        ? await _dio.post<_Json>(
            '$_base/incidents/$id/resolve',
            data: {'resolution': 'Nhân viên ga đã xử lý xong'},
          )
        : await _dio.post<_Json>('$_base/incidents/$id/accept');
    return _parse(res.data!);
  });
}
