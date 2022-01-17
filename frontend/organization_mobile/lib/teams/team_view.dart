import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum TeamNavigationSelector {
  home,
  chat,
}

class TeamView extends StatefulWidget {
  http.Client client;
  Map team;

  TeamView({
    Key? key,
    required this.client,
    required this.team,
  }) : super(key: key);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team["name"]),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {},
          ),
        ]
      ),
      body: Container(),
    );
  }
}