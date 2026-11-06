import 'package:flutter/foundation.dart';

enum IncidentType {
  gate('GATE'),
  lift('LIFT'),
  equipment('EQUIPMENT'),
  hygiene('HYGIENE'),
  security('SECURITY'),
  medical('MEDICAL'),
  parking('PARKING'),
  other('OTHER');

  IncidentType(this.code);
  final String code;

  static IncidentType parse(String? v) =>
      values.where((e) => e.code == v).firstOrNull ?? other;
}

enum IncidentLocation {
  entryGate('ENTRY_GATE'),
  exitGate('EXIT_GATE'),
  concourse('CONCOURSE'),
  platform('PLATFORM'),
  parking('PARKING'),
  other('OTHER');

  IncidentLocation(this.code);
  final String code;

  static IncidentLocation parse(String? v) =>
      values.where((e) => e.code == v).firstOrNull ?? other;
}

enum IncidentSeverity {
  minor('MINOR'),
  operations('OPERATIONS'),
  emergency('EMERGENCY');

  IncidentSeverity(this.code);
  final String code;

  /// Ảnh hưởng tới hành khách nên mặc định đề xuất thông báo.
  bool get affectsPassengers => this != minor;

  static IncidentSeverity parse(String? v) =>
      values.where((e) => e.code == v).firstOrNull ?? minor;
}

enum IncidentStatus {
  open('OPEN'),
  inProgress('IN_PROGRESS'),
  resolved('RESOLVED');

  IncidentStatus(this.code);
  final String code;

  static IncidentStatus parse(String? v) =>
      values.where((e) => e.code == v).firstOrNull ?? open;
}

/// Đề xuất báo hành khách: nhân viên chỉ đề xuất, quản trị viên mới được đăng.
enum IncidentPublication {
  none('NONE'),
  pending('PENDING'),
  published('PUBLISHED');

  IncidentPublication(this.code);
  final String code;

  static IncidentPublication parse(String? v) =>
      values.where((e) => e.code == v).firstOrNull ?? none;
}

/// Một lần đổi trạng thái, để biết ai làm gì và lúc nào.
@immutable
class IncidentEvent {
  const IncidentEvent({
    required this.status,
    required this.actorName,
    required this.at,
  });

  final IncidentStatus status;
  final String actorName;
  final DateTime at;
}

/// Nội dung nhân viên điền để báo sự cố. Ga do backend lấy từ phân công.
@immutable
class IncidentDraft {
  const IncidentDraft({
    required this.type,
    required this.location,
    required this.severity,
    this.description = '',
    this.photos = const [],
    this.proposeToPassengers = false,
  });

  final IncidentType type;
  final IncidentLocation location;
  final IncidentSeverity severity;
  final String description;
  final List<Uint8List> photos;
  final bool proposeToPassengers;
}

/// Sự cố tại ga (`station_incident`).
@immutable
class StationIncident {
  const StationIncident({
    required this.id,
    required this.stationName,
    required this.type,
    required this.location,
    required this.severity,
    required this.status,
    required this.publication,
    required this.reporterName,
    required this.createdAt,
    this.description = '',
    this.photoBytes = const [],
    this.photoUrls = const [],
    this.history = const [],
  });

  final String id;
  final String stationName;
  final IncidentType type;
  final IncidentLocation location;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final IncidentPublication publication;
  final String reporterName;
  final DateTime createdAt;
  final String description;

  /// Ảnh vừa chụp còn trên máy (dữ liệu demo).
  final List<Uint8List> photoBytes;

  /// Ảnh đã tải lên backend.
  final List<String> photoUrls;
  final List<IncidentEvent> history;

  bool get isOpen => status != IncidentStatus.resolved;

  StationIncident copyWith({
    IncidentStatus? status,
    IncidentPublication? publication,
    List<IncidentEvent>? history,
  }) => StationIncident(
    id: id,
    stationName: stationName,
    type: type,
    location: location,
    severity: severity,
    status: status ?? this.status,
    publication: publication ?? this.publication,
    reporterName: reporterName,
    createdAt: createdAt,
    description: description,
    photoBytes: photoBytes,
    photoUrls: photoUrls,
    history: history ?? this.history,
  );
}
