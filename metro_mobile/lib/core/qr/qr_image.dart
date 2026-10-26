import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Vẽ chuỗi thành ảnh QR. Nơi duy nhất import thư viện vẽ QR.
class QrImage extends StatelessWidget {
  const QrImage({
    required this.data,
    this.size = 240,
    this.foreground = const Color(0xFF0B1C2C),
    this.background = const Color(0xFFFFFFFF),
    super.key,
  });

  final String data;
  final double size;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      size: size,
      backgroundColor: background,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: foreground),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foreground,
      ),
    );
  }
}
