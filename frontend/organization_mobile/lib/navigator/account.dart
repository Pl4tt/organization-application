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
  
  bool isLoading = true;

  

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
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(title: const Text("Profile")),
      body: isLoading
        ? const Text("Please authenticate first.")
        : Column(

        ), // TODO: Account overview
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
                builder: (context) => Settings()
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