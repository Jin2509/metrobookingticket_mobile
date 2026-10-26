import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/l10n/l10n.dart';

String stationStructureLabel(AppLocalizations l, StationStructure s) =>
    switch (s) {
      StationStructure.underground => l.structureUnderground,
      StationStructure.elevated => l.structureElevated,
      StationStructure.atGrade => l.structureAtGrade,
    };
