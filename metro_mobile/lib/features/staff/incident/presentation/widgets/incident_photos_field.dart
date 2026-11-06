import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_form_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Tối đa 3 ảnh, không bắt buộc. Chỉ hỏi quyền camera khi bấm chụp.
class IncidentPhotosField extends ConsumerWidget {
  const IncidentPhotosField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = ref.watch(incidentFormProvider);
    final ctrl = ref.read(incidentFormProvider.notifier);
    final full = s.photos.length >= IncidentFormState.maxPhotos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.incidentPhotosTitle(s.photos.length, IncidentFormState.maxPhotos),
          style: context.text.titleSmall,
        ),
        Text(l.incidentPhotosPrivacy, style: context.text.bodySmall),
        MetroSpacing.gapXs,
        if (s.photos.isNotEmpty) ...[
          Row(
            children: [
              for (final (i, photo) in s.photos.indexed) ...[
                if (i > 0) MetroSpacing.gapXs,
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: MetroRadius.brMd,
                      child: Image.memory(
                        photo,
                        width: 88,
                        height: 88,
                        cacheWidth: 264,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton.filledTonal(
                        tooltip: l.incidentPhotoRemove,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(LucideIcons.x, size: 16),
                        onPressed: () => ctrl.removePhoto(i),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          MetroSpacing.gapXs,
        ],
        Row(
          children: [
            Expanded(
              child: MetroButton(
                label: l.incidentTakePhoto,
                icon: LucideIcons.camera,
                variant: MetroButtonVariant.outline,
                expand: true,
                onPressed: full
                    ? null
                    : () => ctrl.addPhoto(ImageSource.camera),
              ),
            ),
            MetroSpacing.gapSm,
            Expanded(
              child: MetroButton(
                label: l.studentChoosePhoto,
                icon: LucideIcons.image,
                variant: MetroButtonVariant.outline,
                expand: true,
                onPressed: full
                    ? null
                    : () => ctrl.addPhoto(ImageSource.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
