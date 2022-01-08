import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final http.Client client;

  const Home({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Icon appBarIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text("Home");
  TextEditingController queryController = new TextEditingController();

  void _search() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              if (appBarIcon.icon == Icons.search) {
                appBarIcon = const Icon(Icons.cancel);
                appBarTitle = ListTile(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28
                    ),
                    onPressed: _search,
                  ),
                  title: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: queryController,
                  ),
                );
              } else {
                appBarIcon = const Icon(Icons.search);
                appBarTitle = const Text("Home");
              }
            });
            },
            icon: appBarIcon
          )
        ]
      ),
      body: const Text("HOME"),
    );
  }
}