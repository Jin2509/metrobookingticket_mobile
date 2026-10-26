import 'package:geolocator/geolocator.dart';

/// Kết quả xin vị trí (UC5-02). Vị trí chỉ dùng trong phiên, không lưu.
sealed class LocationResult {
  const LocationResult();
}

class LocationGranted extends LocationResult {
  const LocationGranted(this.lat, this.lng);
  final double lat;
  final double lng;
}

class LocationDenied extends LocationResult {
  const LocationDenied({this.permanently = false});

  /// `true` thì phải mở Cài đặt để cấp lại.
  final bool permanently;
}

class LocationServiceOff extends LocationResult {
  const LocationServiceOff();
}

abstract interface class LocationService {
  Future<LocationResult> current();
  Future<void> openSettings();
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<LocationResult> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const LocationServiceOff();
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    switch (permission) {
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return const LocationDenied();
      case LocationPermission.deniedForever:
        return const LocationDenied(permanently: true);
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        final p = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            timeLimit: Duration(seconds: 10),
          ),
        );
        return LocationGranted(p.latitude, p.longitude);
    }
  }

  @override
  Future<void> openSettings() => Geolocator.openAppSettings();
}
