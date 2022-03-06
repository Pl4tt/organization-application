import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:organization_mobile/urls.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool initialTheme = false;
  bool systemTheme = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    
    setVariables();
  }

  void setVariables() async {
    initialTheme = await getSharedPrefs("String", theme) == "dark";
    systemTheme = await getSharedPrefs("bool", useSystemTheme);
    
    setState(() => isLoaded = true);
  }

  void switchSystemTheme(bool newSystemTheme) async {
    await setSharedPrefs("bool", useSystemTheme, newSystemTheme);
    setState(() => systemTheme = newSystemTheme);
  }

  Future<void> switchTheme(bool newTheme) async {
    await setSharedPrefs("String", theme, newTheme ? "dark" : "light");
    setState(() => initialTheme = newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body:
        SettingsList(
          sections: [
            SettingsSection(
              title: const Text("Preferences"),
              tiles: [
                SettingsTile.switchTile(
                  leading: const Icon(Icons.format_paint),
                  initialValue: systemTheme,
                  onToggle: switchSystemTheme,
                  title: const Text("Use System Theme"),
                ),
                SettingsTile.switchTile(
                  leading: const Icon(Icons.format_paint),
                  initialValue: initialTheme,
                  onToggle: switchTheme,
                  title: const Text("Dark Theme"),
                ),
              ]
            ),
          ]
        ),
    );
  }
}