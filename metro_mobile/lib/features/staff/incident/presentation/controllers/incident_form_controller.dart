import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_providers.dart';

@immutable
class IncidentFormState {
  const IncidentFormState({
    this.type,
    this.location,
    this.severity,
    this.description = '',
    this.photos = const [],
    this.propose = false,
    this.proposeTouched = false,
    this.submitting = false,
    this.error,
    this.pickFailed = false,
  });

  static const maxPhotos = 3;
  static const maxDescription = 500;

  final IncidentType? type;
  final IncidentLocation? location;
  final IncidentSeverity? severity;
  final String description;
  final List<Uint8List> photos;
  final bool propose;

  /// Nhân viên đã tự chọn thì đổi mức độ không tự bật hay tắt công tắc nữa.
  final bool proposeTouched;
  final bool submitting;
  final String? error;
  final bool pickFailed;

  bool get canSubmit =>
      type != null &&
      location != null &&
      severity != null &&
      (type != IncidentType.other || description.trim().isNotEmpty);

  IncidentFormState copyWith({
    IncidentType? type,
    IncidentLocation? location,
    IncidentSeverity? severity,
    String? description,
    List<Uint8List>? photos,
    bool? propose,
    bool? proposeTouched,
    bool submitting = false,
    String? error,
    bool pickFailed = false,
  }) => IncidentFormState(
    type: type ?? this.type,
    location: location ?? this.location,
    severity: severity ?? this.severity,
    description: description ?? this.description,
    photos: photos ?? this.photos,
    propose: propose ?? this.propose,
    proposeTouched: proposeTouched ?? this.proposeTouched,
    submitting: submitting,
    error: error,
    pickFailed: pickFailed,
  );
}

final incidentFormProvider =
    NotifierProvider.autoDispose<IncidentFormController, IncidentFormState>(
      IncidentFormController.new,
    );

class IncidentFormController extends Notifier<IncidentFormState> {
  @override
  IncidentFormState build() => const IncidentFormState();

  void setType(IncidentType v) => state = state.copyWith(type: v);
  void setLocation(IncidentLocation v) => state = state.copyWith(location: v);
  void setDescription(String v) => state = state.copyWith(description: v);

  void setSeverity(IncidentSeverity v) => state = state.copyWith(
    severity: v,
    propose: state.proposeTouched ? null : v.affectsPassengers,
  );

  void setPropose({required bool value}) =>
      state = state.copyWith(propose: value, proposeTouched: true);

  void removePhoto(int index) =>
      state = state.copyWith(photos: [...state.photos]..removeAt(index));

  Future<void> addPhoto(ImageSource source) async {
    if (state.photos.length >= IncidentFormState.maxPhotos) return;
    try {
      final bytes = await ref.read(incidentPhotoPickerProvider)(source);
      if (!ref.mounted || bytes == null) return;
      state = state.copyWith(photos: [...state.photos, bytes]);
    } on PlatformException {
      if (ref.mounted) state = state.copyWith(pickFailed: true);
    }
  }

  /// Trả `true` khi đã gửi. Lỗi thì giữ nguyên nội dung để gửi lại.
  Future<bool> submit() async {
    final s = state;
    if (!s.canSubmit || s.submitting) return false;
    state = s.copyWith(submitting: true);
    final actor = ref.read(authControllerProvider).value?.name ?? '';
    try {
      await ref
          .read(incidentRepositoryProvider)
          .submit(
            IncidentDraft(
              type: s.type!,
              location: s.location!,
              severity: s.severity!,
              description: s.description.trim(),
              photos: s.photos,
              proposeToPassengers: s.propose,
            ),
            actor,
          );
      ref.invalidate(incidentsProvider);
      return true;
    } on Failure catch (f) {
      if (ref.mounted) state = s.copyWith(error: f.message);
      return false;
    }
  }
}
