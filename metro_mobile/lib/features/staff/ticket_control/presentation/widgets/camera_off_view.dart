import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Camera đang tắt: nhân viên chủ động bật khi cần quét. Chỉ sau khi bấm mới
/// hỏi quyền và mở camera.
class CameraOffView extends StatelessWidget {
  const CameraOffView({required this.onTurnOn, super.key});

  final VoidCallback onTurnOn;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MetroCard(
      child: EmptyState(
        icon: LucideIcons.camera,
        title: l.cameraOffTitle,
        message: l.cameraOffBody,
        actionLabel: l.cameraTurnOn,
        onAction: onTurnOn,
      ),
    );
  }
}
