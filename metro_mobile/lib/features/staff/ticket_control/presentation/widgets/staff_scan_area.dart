import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/permissions/camera_permission.dart';
import 'package:metro_mobile/core/qr/camera_scanner.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/camera_denied_view.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/camera_off_view.dart';

/// Khung quét dùng chung cho soát vé (S10) và gửi xe (S21), mở máy quét qua
/// `core/qr`. Camera tắt sẵn: chỉ hỏi quyền và bật khi nhân viên chọn, tự tắt
/// khi rời màn hoặc đưa app xuống nền. [autoStart]: màn nhân viên vừa bấm
/// "Quét" để vào, coi như đã chọn bật.
class StaffScanArea extends ConsumerStatefulWidget {
  const StaffScanArea({
    required this.onRead,
    this.busy = false,
    this.hint,
    this.autoStart = false,
    super.key,
  });

  final ValueChanged<ScanRead> onRead;
  final bool busy;

  /// Dòng nhắc trong khung quét, ví dụ chế độ đang soát.
  final String? hint;
  final bool autoStart;

  @override
  ConsumerState<StaffScanArea> createState() => _StaffScanAreaState();
}

class _StaffScanAreaState extends ConsumerState<StaffScanArea>
    with WidgetsBindingObserver {
  CameraAccess? _access;
  bool _requesting = false;
  QrScanner? _scanner;
  StreamSubscription<ScanRead>? _sub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.autoStart) unawaited(_turnOn());
  }

  Future<void> _turnOn() async {
    setState(() => _requesting = true);
    final access = await ref.read(cameraPermissionProvider).request();
    if (!mounted) return;
    if (access == CameraAccess.granted && _scanner == null) {
      final scanner = ref.read(qrScannerFactoryProvider)();
      // Gọi `widget.onRead` hiện tại (chế độ có thể đổi sau khi mở).
      _sub = scanner.reads.listen((r) => widget.onRead(r));
      _scanner = scanner;
    }
    setState(() {
      _requesting = false;
      _access = access;
    });
  }

  void _release() {
    unawaited(_sub?.cancel());
    unawaited(_scanner?.dispose());
    _sub = null;
    _scanner = null;
    _access = null;
  }

  void _turnOff() => setState(_release);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sang tab khác thì tab này vẫn sống, nên phải tự tắt camera.
    if (!TickerMode.valuesOf(context).enabled && _scanner != null) _release();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _scanner != null) _turnOff();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanner = _scanner;
    if (_requesting) {
      return const AspectRatio(
        aspectRatio: 1,
        child: MetroSkeleton(radius: MetroRadius.xl),
      );
    }
    return switch (_access) {
      CameraAccess.granted when scanner != null => ScanView(
        preview: scanner.preview(),
        onTorch: () => unawaited(scanner.toggleTorch()),
        onTurnOff: _turnOff,
        busy: widget.busy,
        hint: widget.hint,
      ),
      // Màn soát vé không cuộn: chữ dài hoặc cỡ chữ lớn vẫn đọc hết được.
      null => SingleChildScrollView(child: CameraOffView(onTurnOn: _turnOn)),
      _ => SingleChildScrollView(
        child: CameraDeniedView(
          permanently: _access == CameraAccess.permanentlyDenied,
          onRetry: _turnOn,
          onOpenSettings: () =>
              unawaited(ref.read(cameraPermissionProvider).openSettings()),
        ),
      ),
    };
  }
}
