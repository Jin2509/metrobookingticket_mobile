import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `null` khi backend chưa có thông tin kết cấu ga.
String? stationStructureLabel(AppLocalizations l, StationStructure? s) =>
    switch (s) {
      StationStructure.underground => l.structureUnderground,
      StationStructure.elevated => l.structureElevated,
      StationStructure.atGrade => l.structureAtGrade,
      null => null,
    };

/// Nhãn trạng thái khai thác của ga.
String stationStatusLabel(AppLocalizations l, Station s) => switch (s.status) {
  StationStatus.active => l.inOperation,
  StationStatus.maintenance => l.underMaintenance,
  StationStatus.inactive => l.notInOperation,
};

/// Nhãn trạng thái tuyến; [active] thay nhãn mặc định `Đang khai thác`.
String lineStatusLabel(AppLocalizations l, MetroLine line, {String? active}) =>
    switch (line.status) {
      LineStatus.active => active ?? l.inService,
      LineStatus.planned => l.linePlanned,
      LineStatus.inactive => l.lineSuspended,
    };
