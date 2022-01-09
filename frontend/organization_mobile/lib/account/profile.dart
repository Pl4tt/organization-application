import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final accountData;

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
      body: Column(

      ), // TODO: Profile overview
    );
  }
}