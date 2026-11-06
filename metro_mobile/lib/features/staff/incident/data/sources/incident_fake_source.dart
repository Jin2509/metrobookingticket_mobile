import 'dart:async';

import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/domain/repositories/incident_repository.dart';
import 'package:metro_mobile/features/staff/staff_demo.dart';

/// Giả lập backend sự cố: có 2 sự cố mẫu của ga demo. Đề xuất báo hành khách tự
/// được duyệt sau [approvalDelay] thay cho quản trị viên, rồi hiện ở thẻ thông
/// báo vận hành; sự cố xử lý xong thì gỡ thông báo.
class IncidentFakeSource implements IncidentRepository {
  IncidentFakeSource(
    this._ledger, {
    this.approvalDelay = const Duration(seconds: 5),
  }) {
    final now = _ledger.clock();
    _items.addAll([
      StationIncident(
        id: 'SC-1002',
        stationName: StaffDemo.stationName,
        type: IncidentType.lift,
        location: IncidentLocation.concourse,
        severity: IncidentSeverity.minor,
        status: IncidentStatus.inProgress,
        publication: IncidentPublication.none,
        reporterName: 'Trần Minh',
        createdAt: now.subtract(const Duration(hours: 2)),
        description: 'Thang cuốn phía cửa B phát tiếng ồn lớn.',
        history: [
          IncidentEvent(
            status: IncidentStatus.inProgress,
            actorName: 'Trần Minh',
            at: now.subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      StationIncident(
        id: 'SC-1001',
        stationName: StaffDemo.stationName,
        type: IncidentType.hygiene,
        location: IncidentLocation.platform,
        severity: IncidentSeverity.minor,
        status: IncidentStatus.resolved,
        publication: IncidentPublication.none,
        reporterName: 'Lê Hà',
        createdAt: now.subtract(const Duration(days: 1)),
        description: 'Sàn ướt gần đầu sân ga.',
      ),
    ]);
  }

  final DemoLedger _ledger;
  final Duration approvalDelay;
  final _items = <StationIncident>[];
  int _seq = 1003;

  static const _typeNames = {
    IncidentType.gate: 'Cổng soát vé',
    IncidentType.lift: 'Thang cuốn, thang máy',
    IncidentType.equipment: 'Thiết bị',
    IncidentType.hygiene: 'Vệ sinh',
    IncidentType.security: 'An ninh',
    IncidentType.medical: 'Y tế',
    IncidentType.parking: 'Bãi xe',
    IncidentType.other: 'Sự cố',
  };

  @override
  Future<List<StationIncident>> getIncidents() async => List.of(_items);

  int _indexOf(String id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) throw const NotFoundFailure('Không tìm thấy sự cố');
    return i;
  }

  @override
  Future<StationIncident> submit(IncidentDraft d, String actorName) async {
    final incident = StationIncident(
      id: 'SC-${_seq++}',
      stationName: StaffDemo.stationName,
      type: d.type,
      location: d.location,
      severity: d.severity,
      status: IncidentStatus.open,
      publication: d.proposeToPassengers
          ? IncidentPublication.pending
          : IncidentPublication.none,
      reporterName: actorName,
      createdAt: _ledger.clock(),
      description: d.description,
      photoBytes: d.photos,
    );
    _items.insert(0, incident);
    if (d.proposeToPassengers) {
      if (approvalDelay == Duration.zero) {
        _approve(incident.id);
      } else {
        Timer(approvalDelay, () => _approve(incident.id));
      }
    }
    return incident;
  }

  void _approve(String id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0 || !_items[i].isOpen) return;
    final e = _items[i];
    _items[i] = e.copyWith(publication: IncidentPublication.published);
    // Chỉ công khai tên ga và tình trạng, không có ảnh hay mô tả nội bộ.
    final name = _typeNames[e.type]!;
    _ledger.operationalNews.insert(0, {
      'id': e.id,
      'title': '$name gặp sự cố · Ga ${e.stationName}',
      'summary': 'Nhân viên ga đang xử lý. Vui lòng đi theo hướng dẫn tại ga.',
      'at': _ledger.clock().toIso8601String(),
    });
  }

  @override
  Future<StationIncident> updateStatus(
    String id,
    IncidentStatus status,
    String actorName,
  ) async {
    final i = _indexOf(id);
    final e = _items[i];
    final updated = e.copyWith(
      status: status,
      history: [
        ...e.history,
        IncidentEvent(
          status: status,
          actorName: actorName,
          at: _ledger.clock(),
        ),
      ],
    );
    _items[i] = updated;
    if (status == IncidentStatus.resolved) {
      _ledger.operationalNews.removeWhere((n) => n['id'] == id);
    }
    return updated;
  }
}
