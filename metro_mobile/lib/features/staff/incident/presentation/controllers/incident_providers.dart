import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/staff/incident/data/sources/incident_fake_source.dart';
import 'package:metro_mobile/features/staff/incident/data/sources/incident_remote_source.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/domain/repositories/incident_repository.dart';

final incidentRepositoryProvider = Provider<IncidentRepository>(
  (ref) => Env.useFakeData
      ? IncidentFakeSource(ref.watch(demoLedgerProvider))
      : IncidentRemoteSource(ref.watch(dioProvider)),
);

/// Sự cố của ga. Còn đề xuất chờ duyệt thì tự tải lại khi có màn đang xem.
final incidentsProvider = FutureProvider.autoDispose<List<StationIncident>>((
  ref,
) async {
  final list = await ref.watch(incidentRepositoryProvider).getIncidents();
  if (list.any((e) => e.publication == IncidentPublication.pending)) {
    final timer = Timer(const Duration(seconds: 3), ref.invalidateSelf);
    ref.onDispose(timer.cancel);
  }
  return list;
});

final openIncidentCountProvider = Provider.autoDispose<int>(
  (ref) =>
      ref.watch(incidentsProvider).value?.where((e) => e.isOpen).length ?? 0,
);

final incidentPhotoPickerProvider =
    Provider<Future<Uint8List?> Function(ImageSource)>(
      (_) => (source) async {
        final file = await ImagePicker().pickImage(
          source: source,
          maxWidth: 1600,
          imageQuality: 85,
        );
        return await file?.readAsBytes();
      },
    );
