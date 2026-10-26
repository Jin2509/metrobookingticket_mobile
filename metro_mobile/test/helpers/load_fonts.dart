import 'dart:io';

import 'package:flutter/services.dart';

/// Nạp Be Vietnam Pro + Lucide để golden hiển thị chữ thật thay vì ô vuông.
Future<void> loadAppFonts() async {
  final beVietnam = FontLoader('BeVietnamPro');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    beVietnam.addFont(_read('assets/fonts/BeVietnamPro-$w.ttf'));
  }
  await beVietnam.load();

  final lucide = FontLoader('packages/lucide_icons_flutter/Lucide')
    ..addFont(
      rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
    );
  await lucide.load();
}

Future<ByteData> _read(String path) async {
  final bytes = await File(path).readAsBytes();
  return ByteData.sublistView(bytes);
}
