import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  final SharedPreferences _preferences;

  // We don't want to persist this one
  List<String>? allowedLanguageModels;

  SettingsService(this._preferences);

  /// Persists the user's preferred ThemeMode to local or remote storage.
  set themeMode(ThemeMode theme) {
    _preferences.setString('theme', theme.toString());
  }

  set openAIKey(String key) {
    const regex = r'^sk-[a-zA-Z0-9]{32,}$';
    if (!RegExp(regex).hasMatch(key)) {
      return;
    }

    _preferences.setString('openAIKey', key);
  }

  set languageModel(String model) {
    _preferences.setString('languageModel', model);
  }

  /// Loads the User's preferred ThemeMode from local or remote storage.
  ThemeMode get themeMode {
    final themeText =
        _preferences.getString('theme') ?? ThemeMode.system.toString();
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == themeText,
      orElse: () => ThemeMode.system,
    );
  }

  String get openAIKey {
    return _preferences.getString('openAIKey') ?? '';
  }

  String get languageModel {
    return _preferences.getString('languageModel') ?? 'gpt-3.5-turbo';
  }
}
