import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/login.dart';
import 'package:organization_mobile/account/register.dart';

class ChooseOption extends StatelessWidget {
  final http.Client client;
  final Function callbackRebuild;

  const ChooseOption({
    Key? key,
    required this.client,
    required this.callbackRebuild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Option")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Login(
                  client: client,
                  callbackRebuild: callbackRebuild,
                ))
              ),
              child: const Text("Login")
            ),
            ElevatedButton(onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Register(
                  client: client,
                  callbackRebuild: callbackRebuild,
                ))
              ),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
