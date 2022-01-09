import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/profile.dart';

class Search extends StatefulWidget {
  http.Client client;
  var accounts;

  Search({
    Key? key,
    required this.client,
    required this.accounts,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Results")),
      body: ListView.builder(
        itemCount: widget.accounts.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(widget.accounts[index]["username"]),
            subtitle: Text(widget.accounts[index]["biography"]),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Profile(accountData: widget.accounts[index])
            )),
          );
        },
      )
    );
  }
}