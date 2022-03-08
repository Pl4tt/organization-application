import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/choose_option.dart';
import 'package:organization_mobile/account/settings.dart';
import 'package:organization_mobile/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  final http.Client client;

  const Account({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  AppBar? appBar;

  Map? accountData;
  

  @override
  void initState() {
    super.initState();

    buildAppBar();
    getData();
  }
  
  void _logout() async {
    var prefs = await SharedPreferences.getInstance();

    widget.client.post(
      logoutUrl,
      headers: {
        "Authorization": "Token ${await getToken()}",
      }
    );
    prefs.remove("authtoken");

    buildAppBar();
    getData();
  }

  void getData() async {
    String? token = await getToken();

    if (token == null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChooseOption(
          client: widget.client,
          callbackRebuild: () {
            buildAppBar();
            getData();
          }
        )
      ));
      return null;
    }

    var response = await widget.client.post(
      getAccountDataUrl,
      headers: {
        "Authorization": "Token ${await getToken()}",
      }
    );
    setState(() => accountData = json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(title: const Text("Profile")),
      body: accountData == null
        ? const Text("Please authenticate first.")
        : Center(
          child: Column(
            children: [
              Text(
                '${accountData!["username"]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )
              ),
              Text(
                'Name: ${accountData!["first_name"]} ${accountData!["last_name"]}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                '\n${accountData!["biography"]}',
              ),
              Text(
                '\n\nContact: ${accountData!["email"]}',
              ),
            ],
          ),
        ),
    );
  }

  void buildAppBar() async {
    String? token = await getToken();
    
    if (token == null) {
      setState(() => appBar = AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: "Sign in",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChooseOption(
                client: widget.client,
                callbackRebuild: buildAppBar,
              ))
            ),
          ),
        ],
      ));
      return null;
    }
    setState(() => appBar = AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Account Settings",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Settings(
                  accountData: accountData!,
                  client: widget.client,
                )
              )
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      )
    );
  }
}