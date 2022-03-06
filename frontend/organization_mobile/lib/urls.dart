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

// settings urls
// shared preferences key constants
String theme = "theme";
String useSystemTheme = "useSystemTheme";

Future<void> setSharedPrefs(String type, dynamic key, dynamic value) async {
  final prefs = await SharedPreferences.getInstance();
  
  switch (type) {
    case "String":
      prefs.setString(key, value);
      break;
      
    case "bool":
      prefs.setBool(key, value);
      break;
      
    case "int":
      prefs.setInt(key, value);
      break;

    case "double":
      prefs.setDouble(key, value);
      break;

    case "List<String>":
      prefs.setStringList(key, value);
      break;
  }
}

Future<dynamic> getSharedPrefs(String type, dynamic key) async {
  final prefs = await SharedPreferences.getInstance();

  dynamic result;

  switch (type) {
    case "String":
      result = prefs.getString(key);
      break;
      
    case "bool":
      result = prefs.getBool(key);
      break;
      
    case "int":
      result = prefs.getInt(key);
      break;

    case "double":
      result = prefs.getDouble(key);
      break;

    case "List<String>":
      result = prefs.getStringList(key);
      break;
  }

  return result;
}