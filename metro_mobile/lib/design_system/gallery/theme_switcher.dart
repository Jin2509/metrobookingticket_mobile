import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

enum GalleryTheme {
  light('Light'),
  dark('Dark'),
  staff('Staff');

  GalleryTheme(this.label);
  final String label;
}

/// Chuyển nhanh giữa 3 theme trong gallery.
class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final GalleryTheme value;
  final ValueChanged<GalleryTheme> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: MetroSpacing.xs),
      child: SegmentedButton<GalleryTheme>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: [
          for (final t in GalleryTheme.values)
            ButtonSegment(value: t, label: Text(t.label)),
        ],
        selected: {value},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}
