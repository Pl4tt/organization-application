import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/chat/chat_view.dart';
import 'package:organization_mobile/chat/create_chat.dart';
import 'package:organization_mobile/urls.dart';

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
  dynamic chats;

  @override
  void initState() {
    super.initState();

    _refreshChats();
  }

  Future<void> _refreshChats() async{
    var response = await widget.client.get(
      chatOverviewUrl,
      headers: {
        "Authorization": "Token ${await getToken()}"
      }
    );

    setState(() => chats = json.decode(response.body));
  }

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
      body: RefreshIndicator(
        onRefresh: _refreshChats,
        child: chats != null
          ? ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(chats[index]["chatting_person_username"]),
                subtitle: Text("Created at " + chats[index]["date_created"]),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatView(
                    client: widget.client,
                    chat: {
                      "id": chats[index]["id"],
                      "self": chats[index]["self"],
                      "chatting_person": chats[index]["chatting_person"],
                      "chatting_person_username": chats[index]["chatting_person_username"],
                      "date_created": chats[index]["date_created"],
                    }
                  ),
                ))
              );
            },
          )
          : const Text("loading..."),
      ),
    );
  }
}