import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/urls.dart';

class Register extends StatelessWidget {
  final http.Client client;
  final Function callbackRebuild;

  Register({
    Key? key,
    required this.client,
    required this.callbackRebuild,
  }) : super(key: key);

  // fields = ("email", "username", "first_name", "last_name", "password1", "password2")
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController pass1Controller = TextEditingController();
  TextEditingController pass2Controller = TextEditingController();

  void _register(BuildContext context) async {
    var data = {
      "email": emailController.text,
      "username": usernameController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "password1": pass1Controller.text,
      "password2": pass2Controller.text,
    };
    var response = await client.post(registerUrl, body: data);
    
    if (response.statusCode != 200) {
      return null;
    }

    await obtainToken(emailController.text, pass1Controller.text, client);
    
    callbackRebuild();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
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
              controller: usernameController,
              maxLength: 25,
              decoration: const InputDecoration(
                hintText: "Username",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: firstNameController,
              maxLength: 25,
              decoration: const InputDecoration(
                hintText: "First Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: lastNameController,
              maxLength: 25,
              decoration: const InputDecoration(
                hintText: "Last Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: pass1Controller,
              obscureText: true,
              maxLength: 400,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: pass2Controller,
              obscureText: true,
              maxLength: 400,
              decoration: const InputDecoration(
                hintText: "Confirm Password",
              ),
            ),
          ),
          ElevatedButton(onPressed: () => _register(context), child: const Text("Register")),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
