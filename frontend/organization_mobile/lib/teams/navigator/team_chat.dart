import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamChat extends StatefulWidget {
  final http.Client client;

  const TeamChat({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _TeamChatState createState() => _TeamChatState();
}

class _TeamChatState extends State<TeamChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team Chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {},
          ),
        ],
      ),
      body: Text("team chat"),
    );
  }
}