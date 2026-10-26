import 'dart:math' as math;

/// Khoảng cách theo mét giữa hai tọa độ (công thức haversine).
double distanceMeters(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371000.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * r * math.asin(math.sqrt(a));
}

/// `350 m`, `1,2 km`.
String formatDistance(double meters) {
  if (meters < 1000) return '${meters.round()} m';
  final km = (meters / 100).round() / 10;
  return '${km.toString().replaceAll('.', ',')} km';
}
