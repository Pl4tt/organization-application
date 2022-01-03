import 'package:flutter/material.dart';
import 'package:organization_mobile/account/register.dart';

class Login extends StatelessWidget {
  Login({ Key? key }) : super(key: key);

  // fields = fields = ("email", "password")
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void _login() {}

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
          ElevatedButton(onPressed: _login, child: const Text("Login")),
          ElevatedButton(onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Register())),
            child: const Text("Register instead"),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}