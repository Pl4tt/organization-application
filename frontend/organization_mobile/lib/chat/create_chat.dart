import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/urls.dart';

class CreateChat extends StatelessWidget {
  final http.Client client;
  Function refreshCallback;

  CreateChat({
    Key? key,
    required this.client,
    required this.refreshCallback,
  }) : super(key: key);

  TextEditingController emailController = TextEditingController();

  Future<void> _createChat(BuildContext context) async {
    var response = await client.post(
      createChatUrl,
      headers: {
        "Authorization": "Token ${await getToken()}"
      },
      body: {
        "member_email": emailController.text
      }
    );
    
    if (response.statusCode != 200) {
      return;
    }

    refreshCallback();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Create Chat")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: emailController,
              maxLength: 60,
              decoration: const InputDecoration(
                hintText: "Email Address user you want to chat",
              ),
            ),
          ),
          ElevatedButton(onPressed: () => _createChat(context), child: const Text("Create Chat")),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
