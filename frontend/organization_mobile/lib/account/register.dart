import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/login.dart';

class Register extends StatelessWidget {
  final http.Client client;
  final Function callbackRebuild;

  Register({
    Key? key,
    required this.client,
    required this.callbackRebuild,
  }) : super(key: key);

  // fields = ("email", "username", "first_name", "last_name", "password1", "password2")
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController pass1Controller = new TextEditingController();
  TextEditingController pass2Controller = new TextEditingController();

  void _register() {
    callbackRebuild();
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
          ElevatedButton(onPressed: _register, child: const Text("Register")),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
