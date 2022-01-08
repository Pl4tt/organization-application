import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/choose_option.dart';
import 'package:organization_mobile/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final http.Client client;

  const Profile({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AppBar? appBar;

  @override
  void initState() {
    super.initState();

    buildAppBar();
  }
  
  void _logout() async {
    var prefs = await SharedPreferences.getInstance();

    widget.client.get(
      logoutUrl,
      headers: {
        "Authorization": "Token ${await getToken()}",
      }
    );
    prefs.remove("authtoken");

    buildAppBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(title: const Text("Profile")),
      body: const Text("PROFILE"),
    );
  }

  void buildAppBar() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("authtoken");
    
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
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      )
    );
  }
}