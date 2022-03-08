import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  final Map accountData;

  const AccountSettings({
    Key? key,
    required this.accountData,
  }) : super(key: key);

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account Settings")),
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
              ),
            ),
            Text("Account Settings", style: TextStyle(
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
                    leading: Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
                    title: const Text("Personal Data"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip_outlined, color: Theme.of(context).primaryColor),
                    title: const Text("Privacy Settings"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                    title: const Text("Change Password"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}