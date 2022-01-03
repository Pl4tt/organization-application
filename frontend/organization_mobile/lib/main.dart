import 'package:flutter/material.dart';
import 'package:organization_mobile/navigator/chat.dart';
import 'package:organization_mobile/navigator/home.dart';
import 'package:organization_mobile/navigator/profile.dart';
import 'package:organization_mobile/navigator/teams.dart';

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
  int _counter = 0;
  int _selectedIndex = 0;
  NavigationSelector _currPage = NavigationSelector.home;

  void _incrementCounter() {
    _counter += 1;
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
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
        return Home();
      
      case NavigationSelector.chat:
        return Chat();

      case NavigationSelector.teams:
        return Teams();

      case NavigationSelector.profile:
        return Profile();
    }
  }
}
