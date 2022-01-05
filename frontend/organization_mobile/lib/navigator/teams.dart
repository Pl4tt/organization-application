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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("TEAMS"),
    );
  }
}