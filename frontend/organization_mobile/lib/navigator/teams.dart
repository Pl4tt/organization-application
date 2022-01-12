import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Teams extends StatefulWidget {
  final http.Client client;

  const Teams({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {

  void _createTeam() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams"),
        actions: [
          IconButton(
            icon: Icon(Icons.group_add_sharp),
            iconSize: 35,
            tooltip: "Create Team",
            onPressed: _createTeam,
          )
        ]
      ),
      body: const Text("TEAMS"),
    );
  }
}