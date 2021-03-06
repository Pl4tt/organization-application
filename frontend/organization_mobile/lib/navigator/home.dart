import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organization_mobile/account/search.dart';
import 'package:speech_to_text/speech_to_text.dart'  as stt;


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
  _SearchDelegate? _delegateSearch;
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
              await showSearch<String>(
                context: context,
                delegate: _delegateSearch!,
              );
            }
          )
        ]
      ),
      body: const Text("HOME"),
    );
  }
}


class _SearchDelegate extends SearchDelegate<String> {
  final http.Client client;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  
  List<String> history = [];

  _SearchDelegate({
    required this.client
  });
  

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
          onPressed: _listen,
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
    history.insert(0, query);

    return Search(client: client, query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = query.isEmpty
      ? history
      : history.where((word) => word.startsWith(query)).toList();
    
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        var suggestion = suggestions[index];

        return ListTile(
          leading: const Icon(Icons.history),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
                fontFamily: "Helvetica"
              ),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: const TextStyle(
                    fontWeight: FontWeight.normal
                  )
                )
              ]
            )
          ),
          onTap: () {
            query = suggestion;
            showResults(context);
          }
        );
      }
    );
  }

  _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();

      if (available) {
        _isListening = true;
        _speech.listen(
          onResult: (val) {
            query = val.recognizedWords;
          }
        );
      }
    } else {
      _isListening = false;
      _speech.stop();
    }
  }
}