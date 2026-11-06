import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';

abstract interface class IncidentRepository {
  /// Sự cố của ga đang phân công.
  Future<List<StationIncident>> getIncidents();

  /// [actorName] chỉ để giả lập; backend bản thật lấy người gửi từ token.
  Future<StationIncident> submit(IncidentDraft draft, String actorName);

  Future<StationIncident> updateStatus(
    String id,
    IncidentStatus status,
    String actorName,
  );
}
