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
      body: Container(),
    );
  }
}