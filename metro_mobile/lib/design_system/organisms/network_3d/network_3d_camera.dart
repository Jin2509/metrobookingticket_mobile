import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Điểm trong không gian sơ đồ: x đông, y lên trên, z nam. Mặt đất là y = 0.
@immutable
class Point3 {
  const Point3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}

/// Điểm sau chiếu. [scale] là hệ số phối cảnh, [depth] càng lớn càng xa.
@immutable
class Projected {
  const Projected(this.offset, this.scale, this.depth);

  final Offset offset;
  final double scale;
  final double depth;
}

/// Camera quay quanh tâm sơ đồ, chiếu phối cảnh lên màn hình.
@immutable
class Network3dCamera {
  const Network3dCamera({
    this.yaw = defaultYaw,
    this.pitch = defaultPitch,
    this.zoom = 1,
    this.pan = Offset.zero,
  });

  factory Network3dCamera.lerp(
    Network3dCamera a,
    Network3dCamera b,
    double t,
  ) => Network3dCamera(
    yaw: a.yaw + (b.yaw - a.yaw) * t,
    pitch: a.pitch + (b.pitch - a.pitch) * t,
    zoom: a.zoom + (b.zoom - a.zoom) * t,
    pan: Offset.lerp(a.pan, b.pan, t)!,
  );

  static const defaultYaw = -.55;
  static const defaultPitch = .85;
  static const minPitch = .3;
  static const maxPitch = 1.4;
  static const minZoom = .7;
  static const maxZoom = 3.5;

  /// Khoảng cách camera: nhỏ hơn thì phối cảnh gắt hơn.
  static const _distance = 3.4;

  final double yaw;
  final double pitch;
  final double zoom;
  final Offset pan;

  Projected project(Point3 p, Size size) {
    final cosY = math.cos(yaw);
    final sinY = math.sin(yaw);
    final x = p.x * cosY - p.z * sinY;
    final z = p.x * sinY + p.z * cosY;
    final cosP = math.cos(pitch);
    final sinP = math.sin(pitch);
    final y = p.y * cosP - z * sinP;
    final depth = p.y * sinP + z * cosP;
    final scale = _distance / (_distance + depth);
    final unit = size.shortestSide * .46 * zoom * scale;
    return Projected(
      size.center(Offset.zero) + pan + Offset(x * unit, -y * unit),
      scale,
      depth,
    );
  }

  Network3dCamera copyWith({
    double? yaw,
    double? pitch,
    double? zoom,
    Offset? pan,
  }) => Network3dCamera(
    yaw: yaw ?? this.yaw,
    pitch: (pitch ?? this.pitch).clamp(minPitch, maxPitch),
    zoom: (zoom ?? this.zoom).clamp(minZoom, maxZoom),
    pan: pan ?? this.pan,
  );
}
