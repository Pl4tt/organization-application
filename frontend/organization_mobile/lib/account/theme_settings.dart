import 'package:flutter/material.dart';
import 'package:organization_mobile/urls.dart';

class ThemeSettings extends StatefulWidget {
  String currTheme;
  Function refreshCallback;

  ThemeSettings({
    Key? key,
    required this.currTheme,
    required this.refreshCallback,
  }) : super(key: key);

  @override
  _ThemeSettingsState createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  late String currTheme;

  @override  
  void initState() {
    super.initState();

    currTheme = widget.currTheme;
  }

  @override
  void dispose() {
    widget.refreshCallback();

    super.dispose();
  }

  Future<void> switchTheme(String? newTheme) async {
    await setSharedPrefs("String", theme, newTheme);
    
    setState(() => currTheme = newTheme.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Theme")),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: currTheme,
                    onChanged: switchTheme,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: "system",
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.phone_android),
                            SizedBox(width: 10,),
                            Text(
                              "system",
                              style:  TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      ),
                      DropdownMenuItem<String>(
                        value: "dark",
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.dark_mode),
                            SizedBox(width: 10,),
                            Text(
                              "dark",
                              style:  TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      ),
                      DropdownMenuItem<String>(
                        value: "light",
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.light_mode),
                            SizedBox(width: 10,),
                            Text(
                              "light",
                              style:  TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      ),
                    ]
                  ),
                  ListTile(
                    tileColor: Theme.of(context).primaryColor,
                    title: Center(child: Text("Back", style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ))),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}