import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


var registerUrl = Uri.parse("http://10.0.2.2:8000/account/register");
var loginUrl = Uri.parse("http://10.0.2.2:8000/account/login");
var obtainTokenUrl = Uri.parse("http://10.0.2.2:8000/account/obtain-token");
var getAccountDataUrl = Uri.parse("http://10.0.2.2:8000/account/user");

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
