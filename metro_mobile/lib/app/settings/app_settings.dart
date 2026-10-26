import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Giao diện + ngôn ngữ người dùng chọn (lưu `shared_preferences`).
@immutable
class AppSettings {
  const AppSettings({this.themeMode = ThemeMode.system, this.locale});

  final ThemeMode themeMode;

  /// `null` = tiếng Việt mặc định.
  final Locale? locale;
}

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsController, AppSettings>(
      AppSettingsController.new,
    );

class AppSettingsController extends AsyncNotifier<AppSettings> {
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';

  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = ThemeMode.values.firstWhere(
      (m) => m.name == prefs.getString(_themeKey),
      orElse: () => ThemeMode.system,
    );
    final code = prefs.getString(_localeKey);
    return AppSettings(
      themeMode: theme,
      locale: code == null ? null : Locale(code),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(
      AppSettings(themeMode: mode, locale: state.value?.locale),
    );
    await (await SharedPreferences.getInstance()).setString(
      _themeKey,
      mode.name,
    );
  }

  Future<void> setLocale(Locale locale) async {
    final theme = state.value?.themeMode ?? ThemeMode.system;
    state = AsyncData(AppSettings(themeMode: theme, locale: locale));
    await (await SharedPreferences.getInstance()).setString(
      _localeKey,
      locale.languageCode,
    );
  }
}
