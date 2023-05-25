import 'package:flutter/material.dart';

import '../chat/chat_service.dart';
import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  late String _openAIKey;
  late String _languageModel;

  // We don't want to persist this one
  List<String>? allowedLanguageModels;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  String get openAIKey => _openAIKey;
  String get languageModel => _languageModel;

  // OpenAI object
  OpenAI? _openAI;
  OpenAI? get openAI => _openAI;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = _settingsService.themeMode;
    _openAIKey = _settingsService.openAIKey;
    _languageModel = _settingsService.languageModel;

    if (_openAIKey != "") {
      _openAI = OpenAI(apiKey: openAIKey, model: languageModel);

      // TODO handle invalid key
      allowedLanguageModels = await _openAI?.listModels();
    }

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> setThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    _settingsService.themeMode = newThemeMode;
  }

  Future<void> setOpenAIKey(String newKey) async {
    if (newKey == _openAIKey) return;
    _openAIKey = newKey;
    _settingsService.openAIKey = newKey;

    if (_openAIKey != "") {
      _openAI = OpenAI(apiKey: openAIKey, model: languageModel);

      // TODO handle invalid key
      allowedLanguageModels = await _openAI?.listModels();
    }

    notifyListeners();
  }

  Future<void> setLanguageModel(String? newModel) async {
    if (newModel == null) return;

    // Check that the model is allowed
    if (allowedLanguageModels == null ||
        !allowedLanguageModels!.contains(newModel)) {
      return;
    }

    if (newModel == _languageModel) return;

    _languageModel = newModel;
    _settingsService.languageModel = newModel;
    _openAI = OpenAI(apiKey: openAIKey, model: languageModel);

    notifyListeners();
  }
}
