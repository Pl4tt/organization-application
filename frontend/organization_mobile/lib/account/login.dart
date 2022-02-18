import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/urls.dart';

class Login extends StatelessWidget {
  final http.Client client;
  final Function callbackRebuild;

  Login({
    Key? key,
    required this.client,
    required this.callbackRebuild,
  }) : super(key: key);

  // fields = fields = ("email", "password")
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) async {
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    var response = await client.post(loginUrl, body: data);
    
    if (response.statusCode != 200) {
      return null;
    }

    await obtainToken(emailController.text, passwordController.text, client);
    
    callbackRebuild();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: emailController,
              maxLength: 60,
              decoration: const InputDecoration(
                hintText: "Email Address",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              maxLength: 400,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
          ),
          ElevatedButton(onPressed: () =>_login(context), child: const Text("Login")),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
