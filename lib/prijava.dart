import 'dart:convert';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:scv_app/data.dart';

final String apiUrl = "https://backend.app.scv.si";

Future<UserData> signInUser() async {
    try{
      final result = await FlutterWebAuth.authenticate(url: "$apiUrl/auth/authUrl", callbackUrlScheme: "app");
      final accessToken = Uri.parse(result).queryParameters['accessToken'];
      final refreshToken = Uri.parse(result).queryParameters['refreshToken'];
      final expiresOn = Uri.parse(result).queryParameters['expiresOn'];
      UserData user = await fetchUserData(accessToken.toString());
      return user;
    }catch (e){
      print(e);
      return null;
    }

    // Extract token from resulting url
}

Future<UserData> fetchUserData(String token) async {
  final response = await http
      .get(Uri.parse('$apiUrl/user/get'),headers: {"Authorization":token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var decoded = jsonDecode(response.body);
    UserData user = UserData(decoded['displayName'],decoded['givenName'],decoded['surname'], decoded['mail'], decoded['mobilePhone'], decoded['id'], decoded['userPrincipalName']);
    return user;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user');
  }

  }