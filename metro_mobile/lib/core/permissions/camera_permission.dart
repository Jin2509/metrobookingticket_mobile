import 'package:permission_handler/permission_handler.dart';

enum CameraAccess { granted, denied, permanentlyDenied }

/// Quyền camera cho Staff quét QR (mục 7.4).
abstract interface class CameraPermission {
  Future<CameraAccess> request();
  Future<void> openSettings();
}

class SystemCameraPermission implements CameraPermission {
  const SystemCameraPermission();

  @override
  Future<CameraAccess> request() async {
    final status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) return CameraAccess.granted;
    return status.isPermanentlyDenied || status.isRestricted
        ? CameraAccess.permanentlyDenied
        : CameraAccess.denied;
  }

  @override
  Future<void> openSettings() => openAppSettings();
}
