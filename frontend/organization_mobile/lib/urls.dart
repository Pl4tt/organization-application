import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// token handle
Uri obtainTokenUrl = Uri.parse("http://10.0.2.2:8000/account/obtain-token");

Future<String> obtainToken(String username, String password, http.Client client) async {
  final prefs = await SharedPreferences.getInstance();

  var body = {
    "username": username,
    "password": password
  };

  String token = json.decode((await client.post(obtainTokenUrl, body: body)).body)["token"];

  prefs.setString("authtoken", token);

  return token;
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("authtoken");
}


// account urls
Uri registerUrl = Uri.parse("http://10.0.2.2:8000/account/register");
Uri loginUrl = Uri.parse("http://10.0.2.2:8000/account/login");
Uri logoutUrl = Uri.parse("http://10.0.2.2:8000/account/logout");
Uri getAccountDataUrl = Uri.parse("http://10.0.2.2:8000/account/user");

Uri searchUrl(String query) =>
  Uri.parse("http://10.0.2.2:8000/account/search?search-query=$query");

Uri getUserDataUrl(int id) =>
  Uri.parse("http://10.0.2.2:8000/account/user?user-id=$id");
  

// team urls
Uri createTeamUrl = Uri.parse("http://10.0.2.2:8000/teams/create");
Uri teamOverviewUrl = Uri.parse("http://10.0.2.2:8000/teams");


// chat urls
Uri chatSocketUrl(int id) =>
  Uri.parse("wss://10.0.2.2/ws/chat/$id");

Uri createChatUrl = Uri.parse("http://10.0.2.2:8000/chat/create");