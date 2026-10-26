import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/app/settings/app_settings.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Cài đặt ứng dụng: giao diện (chỉ Passenger) và ngôn ngữ vi/en.
class AppSettingsSection extends ConsumerWidget {
  const AppSettingsSection({required this.showAppearance, super.key});

  /// Staff luôn dùng theme tối nên ẩn lựa chọn giao diện.
  final bool showAppearance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(appSettingsProvider).value ?? const AppSettings();
    final ctrl = ref.read(appSettingsProvider.notifier);
    final lang = s.locale?.languageCode ?? 'vi';
    return SectionCard(
      title: l.settingsTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showAppearance) ...[
            Text(l.appearance, style: context.text.labelMedium),
            MetroSpacing.gapXs,
            SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l.appearanceSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l.appearanceLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l.appearanceDark),
                ),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => ctrl.setThemeMode(v.first),
            ),
            MetroSpacing.gapMd,
          ],
          Text(l.language, style: context.text.labelMedium),
          MetroSpacing.gapXs,
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'vi', label: Text('Tiếng Việt')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {lang},
            onSelectionChanged: (v) => ctrl.setLocale(Locale(v.first)),
          ),
        ],
      ),
    );
  }
}
