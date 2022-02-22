import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamHome extends StatefulWidget {
  final http.Client client;

  const TeamHome({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _TeamHomeState createState() => _TeamHomeState();
}

class _TeamHomeState extends State<TeamHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {},
          ),
        ],
      ),
      body: Text("team home"),
    );
  }
}