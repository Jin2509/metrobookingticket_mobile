// Sinh ảnh gốc của icon app từ `MascotPainter`, để icon luôn khớp linh vật.
// Chạy: flutter test tool/generate_app_icon_test.dart rồi python3 tool/resize_app_icon.py
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/organisms/mascot/mascot_painter.dart';

Future<void> _render(String path, int size, double scale, {Color? bg}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final s = size.toDouble();
  if (bg != null)
    canvas.drawRect(Rect.fromLTWH(0, 0, s, s), Paint()..color = bg);
  final inner = s * scale;
  canvas.translate((s - inner) / 2, (s - inner) / 2);
  const MascotPainter(blink: false).paint(canvas, Size.square(inner));
  final image = await recorder.endRecording().toImage(size, size);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(data!.buffer.asUint8List());
}

void main() {
  test('sinh icon', () async {
    await _render(
      'build/icon/full.png',
      1024,
      .74,
      bg: const Color(0xFF06192C),
    );
    await _render('build/icon/foreground.png', 432, .56);
  });
}
