import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamFiles extends StatefulWidget {
  final http.Client client;

  const TeamFiles({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _TeamFilesState createState() => _TeamFilesState();
}

class _TeamFilesState extends State<TeamFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Files"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {},
          ),
        ],
      ),
      body: const Text("team files"),
    );
  }
}