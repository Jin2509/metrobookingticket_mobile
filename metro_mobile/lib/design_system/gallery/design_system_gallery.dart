import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/pages/atoms_page.dart';
import 'package:metro_mobile/design_system/gallery/pages/molecules_page.dart';
import 'package:metro_mobile/design_system/gallery/pages/tokens_page.dart';
import 'package:metro_mobile/design_system/gallery/theme_switcher.dart';
import 'package:metro_mobile/design_system/theme/metro_theme.dart';

export 'theme_switcher.dart' show GalleryTheme;

enum GalleryPage { tokens, atoms, molecules }

/// Trang review UI giống Storybook. Chỉ đăng ký route ở flavor dev.
class DesignSystemGallery extends StatefulWidget {
  const DesignSystemGallery({
    this.initial = GalleryTheme.light,
    this.initialPage = GalleryPage.tokens,
    super.key,
  });

  final GalleryTheme initial;
  final GalleryPage initialPage;

  @override
  State<DesignSystemGallery> createState() => _DesignSystemGalleryState();
}

class _DesignSystemGalleryState extends State<DesignSystemGallery> {
  late GalleryTheme _theme = widget.initial;

  ThemeData get _data => switch (_theme) {
    GalleryTheme.light => MetroTheme.light,
    GalleryTheme.dark => MetroTheme.dark,
    GalleryTheme.staff => MetroTheme.staff,
  };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _data,
      child: DefaultTabController(
        length: GalleryPage.values.length,
        initialIndex: widget.initialPage.index,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Design System'),
            actions: [
              ThemeSwitcher(
                value: _theme,
                onChanged: (t) => setState(() => _theme = t),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Tokens'),
                Tab(text: 'Atoms'),
                Tab(text: 'Molecules'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [TokensPage(), AtomsPage(), MoleculesPage()],
          ),
        ),
      ),
    );
  }
}
