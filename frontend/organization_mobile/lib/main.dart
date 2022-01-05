import 'package:flutter/material.dart';
import 'package:organization_mobile/account/choose_option.dart';
import 'package:organization_mobile/navigator/chat.dart';
import 'package:organization_mobile/navigator/home.dart';
import 'package:organization_mobile/navigator/profile.dart';
import 'package:organization_mobile/navigator/teams.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
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
  int _selectedIndex = 0;
  NavigationSelector _currPage = NavigationSelector.home;
  http.Client client = http.Client();

  AppBar? appBar;

  @override
  void initState() {
    super.initState();

    buildAppBar();
  }

  void _logout() async {
    var prefs = await SharedPreferences.getInstance();

    client.get(
      logoutUrl,
      headers: {
        "Authorization": "Token ${await getToken()}",
      }
    );
    prefs.remove("authtoken");

    buildAppBar();
  }
  
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
      appBar: appBar == null
        ? AppBar(title: Text(widget.title))
        : appBar!,
      body: buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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
        return Profile(client: client);
    }
  }

  void buildAppBar() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("authtoken");

    if (token == null) {
      setState(() => appBar = AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: "Sign in",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChooseOption(
                client: client,
                callbackRebuild: buildAppBar,
              ))
            ),
          ),
        ],
      ));
      return null;
    }
    setState(() => appBar = AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      )
    );
  }
}