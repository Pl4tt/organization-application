import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/urls.dart';

class CreateTeam extends StatelessWidget {
  final http.Client client;
  final callBackRefresh;

  CreateTeam({
    Key? key,
    required this.client,
    required this.callBackRefresh,
  }) : super(key: key);

  TextEditingController nameController = new TextEditingController();

  void _createTeam(BuildContext context) async {
    int ownerId = json.decode((await client.post(
      getAccountDataUrl,
      headers: {
        "Authorization": "Token ${await getToken()}"
      },
    )).body)["id"];
    
    client.post(
      createTeamUrl,
      headers: {
        "Authorization": "Token ${await getToken()}",
      },
      body: {
        "owner_id": ownerId.toString(),
        "name": nameController.text,
      }
    );

    callBackRefresh();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Team"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: nameController,
              maxLength: 60,
              decoration: const InputDecoration(
                hintText: "Team Name",
              ),
            ),
          ),
          ElevatedButton(onPressed: () => _createTeam(context), child: const Text("Create Team")),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
