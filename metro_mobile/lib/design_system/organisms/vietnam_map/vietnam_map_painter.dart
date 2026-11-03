import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:metro_mobile/design_system/organisms/vietnam_map/vietnam_map_data.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

List<Offset> _parse(String data) => [
  for (final pair in data.trim().split(' '))
    Offset(double.parse(pair.split(',')[0]), double.parse(pair.split(',')[1])),
];

final _mainland = _parse(VietnamMapData.mainland);
final _islands = VietnamMapData.islands.map(_parse).toList();
final _coastalDots = _parse(VietnamMapData.coastalDots);
final _hoangSa = _parse(VietnamMapData.hoangSa);
final _truongSa = _parse(VietnamMapData.truongSa);

/// Vẽ bản đồ Việt Nam đầy đủ Hoàng Sa, Trường Sa bằng phép chiếu trụ đều.
class VietnamMapPainter extends CustomPainter {
  const VietnamMapPainter({
    required this.color,
    required this.highlight,
    required this.hoangSaLabel,
    required this.truongSaLabel,
    this.markerLabel,
  });

  static const _west = 101.8;
  static const _east = 116.4;
  static const _north = 23.6;
  static const _south = 7.5;

  /// Một độ kinh tuyến ngắn lại theo cos của vĩ độ giữa.
  static final _lngScale = math.cos((_north + _south) / 2 * math.pi / 180);

  /// Tỉ lệ rộng/cao của khung bản đồ.
  static final aspectRatio = (_east - _west) * _lngScale / (_north - _south);

  /// Vị trí TP.HCM.
  static const _hcmc = Offset(106.70, 10.78);

  final Color color;
  final Color highlight;
  final String hoangSaLabel;
  final String truongSaLabel;
  final String? markerLabel;

  Offset _at(Offset p, Size s) => Offset(
    (p.dx - _west) / (_east - _west) * s.width,
    (_north - p.dy) / (_north - _south) * s.height,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color.withValues(alpha: .07);
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeJoin = StrokeJoin.round
      ..color = color.withValues(alpha: .26);
    for (final ring in [_mainland, ..._islands]) {
      final path = Path()
        ..addPolygon([for (final p in ring) _at(p, size)], true);
      canvas
        ..drawPath(path, fill)
        ..drawPath(path, outline);
    }
    final dot = Paint()..color = color.withValues(alpha: .75);
    for (final p in _coastalDots) {
      canvas.drawCircle(_at(p, size), 1.2, dot);
    }
    for (final p in [..._hoangSa, ..._truongSa]) {
      canvas.drawCircle(_at(p, size), 1.6, dot);
    }
    _label(canvas, hoangSaLabel, _at(const Offset(112, 17.35), size));
    _label(canvas, truongSaLabel, _at(const Offset(113.6, 11.85), size));
    _marker(canvas, _at(_hcmc, size));
  }

  void _label(Canvas canvas, String text, Offset center, {Color? ink}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: MetroTypography.label.copyWith(
          color: ink ?? color.withValues(alpha: .9),
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height));
  }

  void _marker(Canvas canvas, Offset at) {
    canvas
      ..drawCircle(at, 8, Paint()..color = highlight.withValues(alpha: .25))
      ..drawCircle(at, 3.2, Paint()..color = highlight);
    if (markerLabel != null) {
      _label(canvas, markerLabel!, at - const Offset(0, 9), ink: highlight);
    }
  }

  @override
  bool shouldRepaint(VietnamMapPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.highlight != highlight ||
      oldDelegate.hoangSaLabel != hoangSaLabel ||
      oldDelegate.truongSaLabel != truongSaLabel ||
      oldDelegate.markerLabel != markerLabel;
}
