import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/settings/account_settings.dart';
import 'package:organization_mobile/account/settings/notification_settings.dart';
import 'package:organization_mobile/account/settings/theme_settings.dart';
import 'package:organization_mobile/urls.dart';

class Settings extends StatefulWidget {
  final Map accountData;
  final http.Client client;

  const Settings({
    Key? key,
    required this.accountData,
    required this.client,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String currTheme = "system";
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    
    setVariables();
  }

  void setVariables() async {
    currTheme = await getSharedPrefs("String", theme);
    
    setState(() => isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 3,
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Theme.of(context).primaryColor,
              child: ListTile(
                title: Text(widget.accountData["username"], style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )),
                leading: const Icon(Icons.person, color: Colors.white),
                trailing: const Icon(Icons.edit, color: Colors.white),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountSettings(
                    accountData: widget.accountData,
                  )
                )),
              ),
            ),
            Text("Preference Settings", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
            Card(
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.format_paint, color: Theme.of(context).primaryColor),
                    title: const Text("Theme"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ThemeSettings(
                        currTheme: currTheme,
                        refreshCallback: setVariables,
                      ),
                    )),
                  ),
                  ListTile(
                    leading: Icon(Icons.format_paint, color: Theme.of(context).primaryColor),
                    title: const Text("Notifications"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationSettings(),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}