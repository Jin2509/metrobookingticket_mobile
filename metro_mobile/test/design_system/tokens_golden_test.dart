@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/gallery/design_system_gallery.dart';
import 'package:metro_mobile/l10n/l10n.dart';

import '../helpers/load_fonts.dart';

/// Golden từng trang gallery × 3 theme × 2 khổ màn (360, 412).
/// Khung cao để chụp hết nội dung trang.
void main() {
  setUpAll(loadAppFonts);

  const heights = {
    GalleryPage.tokens: 1700.0,
    GalleryPage.atoms: 1500.0,
    GalleryPage.molecules: 2550.0,
  };

  for (final page in GalleryPage.values) {
    for (final theme in GalleryTheme.values) {
      for (final width in [360.0, 412.0]) {
        final name = '${page.name}_${theme.name}_${width.toInt()}';
        testWidgets(name, (tester) async {
          tester.view
            ..physicalSize = Size(width, heights[page]!)
            ..devicePixelRatio = 1;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            MaterialApp(
              locale: const Locale('vi'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              debugShowCheckedModeBanner: false,
              home: DesignSystemGallery(initial: theme, initialPage: page),
            ),
          );
          await tester.pump(const Duration(milliseconds: 300));
          await expectLater(
            find.byType(DesignSystemGallery),
            matchesGoldenFile('goldens/$name.png'),
          );
        });
      }
    }
  }
}
