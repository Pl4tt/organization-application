import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/profile.dart';
import 'package:organization_mobile/urls.dart';

class Search extends StatefulWidget {
  final http.Client client;
  final String query;

  const Search({
    Key? key,
    required this.client,
    required this.query,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  dynamic results;
  bool searchDone = false;

  @override
  void initState() {
    super.initState();

    _search();
  }

  Future<void> _search() async {
    setState(() => searchDone = false);

    String searchQuery = widget.query;

    results = json.decode((await widget.client.get(
      searchUrl(searchQuery)
    )).body);

    setState(() => searchDone = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: searchDone && results.isNotEmpty
      ? ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(results[index]["username"]),
              subtitle: Text(results[index]["biography"]),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Profile(accountData: results[index])
              )),
            );
          },
        )
      : const Text("No results"),
    );
  }
}