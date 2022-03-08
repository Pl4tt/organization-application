import 'package:flutter/material.dart';
import 'package:organization_mobile/navigator/chat.dart';
import 'package:organization_mobile/navigator/home.dart';
import 'package:organization_mobile/navigator/account.dart';
import 'package:organization_mobile/navigator/teams.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:http/http.dart' as http;

enum NavigationSelector {
  home,
  chat,
  teams,
  profile,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organization Application',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black54,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Organization Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 3;
  NavigationSelector _currPage = NavigationSelector.profile;
  http.Client client = http.Client();

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _currPage = NavigationSelector.home;
        break;

      case 1:
        _currPage = NavigationSelector.chat;
        break;

      case 2:
        _currPage = NavigationSelector.teams;
        break;

      case 3:
        _currPage = NavigationSelector.profile;
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
      bottomNavigationBar: ConvexAppBar.badge(
        const {},
        style: TabStyle.textIn,
        items: const <TabItem>[
          TabItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(
              Icons.chat_rounded,
              color: Colors.white,
            ),
            title: 'Chat',
          ),
          TabItem(
            icon: Icon(
              Icons.group,
              color: Colors.white,
            ),
            title: 'Teams',
          ),
          TabItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            title: 'Profile',
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildContent() {
    switch (_currPage) {
      case NavigationSelector.home:
        return Home(client: client);

      case NavigationSelector.chat:
        return Chat(client: client);

      case NavigationSelector.teams:
        return Teams(client: client);

      case NavigationSelector.profile:
        return Account(client: client);
    }
  }
}
