import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatView extends StatefulWidget {
  http.Client client;
  Map chat;

  ChatView({
    Key? key,
    required this.client,
    required this.chat,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat["chatting_person_username"]),
      ),
      body: Container(),
    );
  }
}