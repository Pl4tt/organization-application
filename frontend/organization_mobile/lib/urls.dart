import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// token handle
var obtainTokenUrl = Uri.parse("http://10.0.2.2:8000/account/obtain-token");

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
var registerUrl = Uri.parse("http://10.0.2.2:8000/account/register");
var loginUrl = Uri.parse("http://10.0.2.2:8000/account/login");
var logoutUrl = Uri.parse("http://10.0.2.2:8000/account/logout");
var getAccountDataUrl = Uri.parse("http://10.0.2.2:8000/account/user");

Uri searchUrl(String query) =>
  Uri.parse("http://10.0.2.2:8000/account/search?search-query=$query");

Uri getUserDataUrl(int id) =>
  Uri.parse("http://10.0.2.2:8000/account/user?user-id=$id");
  
