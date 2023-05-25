import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  Future<void> _launchURL() async {
    final uri = Uri.parse("https://platform.openai.com/account/api-keys");
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'Could not launch $uri';
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        heightFactor: null,
        child: Container(
          width: 1000,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: ListView(
            children: [
              Card(
                child: DropdownButton<ThemeMode>(
                  // Read the selected themeMode from the controller
                  value: controller.themeMode,
                  // Call the updateThemeMode method any time the user selects a theme.
                  onChanged: controller.setThemeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme'),
                    )
                  ],
                ),
              ),
              // OpenAI API Key
              Card(
                child: ListTile(
                  subtitle: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'OpenAI API Key',
                    ),
                    controller:
                        TextEditingController(text: controller.openAIKey),
                    onChanged: controller.setOpenAIKey,
                  ),
                ),
              ),
              // Model selection
              Card(
                child: DropdownButton<String>(
                  // Read the selected themeMode from the controller
                  value: controller.languageModel,
                  // Call the updateThemeMode method any time the user selects a theme.
                  onChanged: controller.setLanguageModel,
                  items: controller.allowedLanguageModels
                          ?.map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList() ??
                      [],
                ),
              ),
              // Link to OpenAI API key page
              Card(
                child: ListTile(
                  title: const Text('Get an OpenAI API Key'),
                  subtitle: const Text(
                      'You must have an OpenAI API key to use this app.'),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: _launchURL,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
