import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Tuyến minh họa `●───●───●`, cùng ngôn ngữ hình ảnh với
/// `LineIllustration` trên trang login web. Dùng ở Splash và A1.
class LineIllustration extends StatelessWidget {
  const LineIllustration({
    this.stations = 6,
    this.from = 'Bến Thành',
    this.to = 'Suối Tiên',
    super.key,
  });

  final int stations;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final labelStyle = context.text.labelSmall?.copyWith(
      color: m.sidebarForeground,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 16,
          child: CustomPaint(
            painter: _LinePainter(stations: stations, color: m.sidebarPrimary),
          ),
        ),
        MetroSpacing.gapXs,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(from, style: labelStyle),
            Text(to, style: labelStyle),
          ],
        ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({required this.stations, required this.color});

  final int stations;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    const r = 5.0;
    final line = Paint()
      ..color = color
      ..strokeWidth = 3;
    canvas.drawLine(Offset(r, y), Offset(size.width - r, y), line);
    final step = (size.width - 2 * r) / (stations - 1);
    final fill = Paint()..color = MetroColors.sidebar;
    final ring = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (var i = 0; i < stations; i++) {
      final c = Offset(r + step * i, y);
      final isEnd = i == 0 || i == stations - 1;
      canvas
        ..drawCircle(c, isEnd ? r + 1.5 : r, fill)
        ..drawCircle(c, isEnd ? r + 1.5 : r, ring);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.stations != stations || old.color != color;
}
