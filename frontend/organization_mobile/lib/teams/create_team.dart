import 'package:flutter/material.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({ Key? key }) : super(key: key);

  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Team"),
      ),
    );
  }
}