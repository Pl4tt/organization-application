import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/teams/navigator/team_chat.dart';
import 'package:organization_mobile/teams/navigator/team_files.dart';
import 'package:organization_mobile/teams/navigator/team_home.dart';

enum TeamNavigationSelector {
  home,
  chat,
  files,
}

class TeamView extends StatefulWidget {
  http.Client client;
  Map team;

  TeamView({
    Key? key,
    required this.client,
    required this.team,
  }) : super(key: key);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  int _selectedIndex = 0;
  TeamNavigationSelector _currPage = TeamNavigationSelector.home;
  
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _currPage = TeamNavigationSelector.home;
        break;
      
      case 1:
        _currPage = TeamNavigationSelector.chat;
        break;
      
      case 2:
        _currPage = TeamNavigationSelector.files;
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Files",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      )
    );
  }
  
  Widget buildContent() {
    switch (_currPage) {
      case TeamNavigationSelector.home:
        return TeamHome(client: widget.client);
      
      case TeamNavigationSelector.chat:
        return TeamChat(client: widget.client);

      case TeamNavigationSelector.files:
        return TeamFiles(client: widget.client);
    }
  }
}