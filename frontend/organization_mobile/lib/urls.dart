import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const httpProtocol = "http";
const wsProtocol = "ws";
const baseUrl = "10.0.2.2:8000";

// token handle
Uri obtainTokenUrl = Uri.parse("$httpProtocol://$baseUrl/account/obtain-token");

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
Uri registerUrl = Uri.parse("$httpProtocol://$baseUrl/account/register");
Uri loginUrl = Uri.parse("$httpProtocol://$baseUrl/account/login");
Uri logoutUrl = Uri.parse("$httpProtocol://$baseUrl/account/logout");
Uri getAccountDataUrl = Uri.parse("$httpProtocol://$baseUrl/account/user");

Uri searchUrl(String query) =>
  Uri.parse("$httpProtocol://$baseUrl/account/search?search-query=$query");

Uri getUserDataUrl(int id) =>
  Uri.parse("$httpProtocol://$baseUrl/account/user?user-id=$id");
  

// team urls
Uri createTeamUrl = Uri.parse("$httpProtocol://$baseUrl/teams/create");
Uri teamOverviewUrl = Uri.parse("$httpProtocol://$baseUrl/teams");


// chat urls
Uri chatSocketUrl(int id) =>
  Uri.parse("$wsProtocol://$baseUrl/ws/chat/$id");

Uri createChatUrl = Uri.parse("$httpProtocol://$baseUrl/chat/create");
Uri chatOverviewUrl = Uri.parse("$httpProtocol://$baseUrl/chat");

Uri retrieveMessageUrl(int id)
  => Uri.parse("$httpProtocol://$baseUrl/chat/retrieve-messages/$id");

Uri messageUrl(int id)
  => Uri.parse("$httpProtocol://$baseUrl/chat/message/$id");

Future<String?> getPrivateKey() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("RSAprivateKey");
}

