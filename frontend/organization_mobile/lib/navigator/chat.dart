import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/chat/create_chat.dart';

class Chat extends StatefulWidget {
  final http.Client client;

  const Chat({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  void _refreshChats() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_sharp),
            iconSize: 35,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateChat(
                client: widget.client,
                refreshCallback: _refreshChats,
              ),
            )),
          ),
        ],
      ),
      body: const Text("CHAT"),
    );
  }
}