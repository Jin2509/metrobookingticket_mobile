import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/permissions/camera_permission.dart';
import 'package:metro_mobile/core/qr/camera_scanner.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/camera_denied_view.dart';

/// Xin quyền camera, mở máy quét qua `core/qr` (không gọi thẳng
/// `mobile_scanner`), chuyển mỗi lần đọc cho [onRead]. Dùng chung cho
/// soát vé (S10) và gửi xe (S21).
class StaffScanArea extends ConsumerStatefulWidget {
  const StaffScanArea({required this.onRead, this.busy = false, super.key});

  final ValueChanged<ScanRead> onRead;
  final bool busy;

  @override
  ConsumerState<StaffScanArea> createState() => _StaffScanAreaState();
}

class _StaffScanAreaState extends ConsumerState<StaffScanArea> {
  CameraAccess? _access;
  QrScanner? _scanner;
  StreamSubscription<ScanRead>? _sub;

  @override
  void initState() {
    super.initState();
    unawaited(_request());
  }

  Future<void> _request() async {
    final access = await ref.read(cameraPermissionProvider).request();
    if (!mounted) return;
    if (access == CameraAccess.granted && _scanner == null) {
      final scanner = ref.read(qrScannerFactoryProvider)();
      // Gọi `widget.onRead` hiện tại (chế độ có thể đổi sau khi mở).
      _sub = scanner.reads.listen((r) => widget.onRead(r));
      _scanner = scanner;
    }
    setState(() => _access = access);
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    unawaited(_scanner?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanner = _scanner;
    return switch (_access) {
      null => const AspectRatio(
        aspectRatio: 1,
        child: MetroSkeleton(radius: MetroRadius.xl),
      ),
      CameraAccess.granted when scanner != null => ScanView(
        preview: scanner.preview(),
        onTorch: () => unawaited(scanner.toggleTorch()),
        busy: widget.busy,
      ),
      _ => CameraDeniedView(
        permanently: _access == CameraAccess.permanentlyDenied,
        onRetry: _request,
        onOpenSettings: () =>
            unawaited(ref.read(cameraPermissionProvider).openSettings()),
      ),
    };
  }
}
