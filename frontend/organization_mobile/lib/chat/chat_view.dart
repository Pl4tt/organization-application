import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/urls.dart';
import 'package:web_socket_channel/io.dart';

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
  TextEditingController messageController = TextEditingController();
  Map<String, dynamic>? authHeader;
  var chatSocket;
  var messageList = [];

  @override
  void initState() {
    super.initState();

    _setHeader()
      .then((_) =>
        setState(() => chatSocket = IOWebSocketChannel.connect(
          chatSocketUrl(widget.chat["id"]),
          headers: authHeader
        ))
      );
  }

  @override
  void dispose() {
    chatSocket.sink.close();
    
    super.dispose();
  }

  void loadMessages() {}

  void sendMessage() {
    chatSocket.sink.add(json.encode({
      "message": messageController.text
    }));
    
    setState(() => messageController.text = "");
  }

  void sendAttachment() async {}

  Future <void> _setHeader() async{
    authHeader = {
      "authorization": "Token ${await getToken()}"
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat["chatting_person_username"]),
      ),
      body: Stack(
        children: chatSocket != null
        ? <Widget>[
            StreamBuilder(
              stream: chatSocket.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  messageList.add(snapshot.data);
                  return messageDisplay();
                }
                return const Text("no messages");
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => sendAttachment(),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                        controller: messageController,
                      ),
                    ),
                    const SizedBox(width: 15,),
                    FloatingActionButton(
                      onPressed: sendMessage,
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
                      tooltip: "Send Mesage",
                      backgroundColor: Colors.green,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ]
        : <Widget>[
          const Text("loading..."),
        ],
      ),
    );
  }

  Widget messageDisplay() {
    return ListView.builder(
      itemCount: messageList.length,
      itemBuilder: (BuildContext context, int index) {
        var value = json.decode(messageList[index]);

        return ListTile(
          title: Text(value["username"]),
          subtitle: Text(value["message"]),
        );
      }
    );
  }
}