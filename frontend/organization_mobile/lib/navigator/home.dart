import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/search.dart';
import 'package:shimmer/shimmer.dart';

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
  var _delegateSearch;
  Icon appBarIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text("Home");
  TextEditingController queryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _delegateSearch = _SearchDelegate(client: widget.client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
            tooltip: "Search",
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? selected = await showSearch<String>(
                context: context,
                delegate: _delegateSearch,
              );
              if (mounted && selected != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You've selected the word: $selected")
                  ),
                );
              }
            }
          )
        ]
      ),
      body: const Text("HOME"),
    );
  }
}


class _SearchDelegate extends SearchDelegate<String> {
  final client;
  var results;

  _SearchDelegate({
    required http.Client client
  }) : client = client;
  

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: "Back",
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      }
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
      ? IconButton(
          tooltip: "Voice Search",
          icon: const Icon(Icons.mic),
          onPressed: () {
            query = "TODO: implement voice";
          }
        )
      : IconButton(
          tooltip: "Clear",
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
            showSuggestions(context);
          }
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {    
    return Search(client: client, query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
          child: const Text("child")
        )
      ]
    );
  }
}