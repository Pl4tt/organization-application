import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final Map accountData;

  const Profile({
    Key? key,
    required this.accountData
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.accountData["username"])),
      body: Center(
        child: Column(
          children: [
            Text(
              '${widget.accountData["username"]}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              )
            ),
            Text(
              'Name: ${widget.accountData["first_name"]} ${widget.accountData["last_name"]}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              '\n${widget.accountData["biography"]}',
            ),
            Text(
              '\n\nContact: ${widget.accountData["email"]}',
            ),
          ],
        ),
      ),
    );
  }
}