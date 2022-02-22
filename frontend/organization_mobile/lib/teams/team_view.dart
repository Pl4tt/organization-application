import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      appBar: AppBar(
        title: Text(widget.team["name"]),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {},
          ),
        ]
      ),
      body: Container(),
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
}