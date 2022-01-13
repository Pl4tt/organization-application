import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/teams/create_team.dart';
import 'package:organization_mobile/urls.dart';

class Teams extends StatefulWidget {
  final http.Client client;

  const Teams({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  var teams;

  @override
  void initState() {
    super.initState();

    _refreshTeams();
  }

  Future<void> _refreshTeams() async{
    var response = await widget.client.get(
      teamOverviewUrl,
      headers: {
        "Authorization": "Token ${await getToken()}"
      }
    );

    setState(() => teams = json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams"),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_sharp),
            iconSize: 35,
            tooltip: "Create Team",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateTeam(
                  client: widget.client,
                  callBackRefresh: _refreshTeams,
                ),
              )
            ),
          )
        ]
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTeams,
        child: teams != null
          ? ListView.builder(
            itemCount: teams.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(teams[index]["name"]),
                subtitle: Text("Created at " + teams[index]["date_created"]),
                onTap: () => {}, // TODO: navigation
              );
            },
          )
          : const Text("loading..."),
      ),
    );
  }
}