import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:scv_app/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

final String apiUrl = "https://backend.app.scv.si";

final String keyForAccessToken = "key_AccessToken";
final String keyForRefreshToken= "key_RefreshToken";
final String keyForExpiresOn = "key_ExpiresOn";

Future<UserData> signInUser() async {
    try{
      final result = await FlutterWebAuth.authenticate(url: "$apiUrl/auth/authUrl", callbackUrlScheme: "app");
      final accessToken = Uri.parse(result).queryParameters['accessToken'];
      final refreshToken = Uri.parse(result).queryParameters['refreshToken'];
      final expiresOn = Uri.parse(result).queryParameters['expiresOn'];
      UserData user = await fetchUserData(accessToken.toString());
      if(user != null){
        await shraniUporabnikovePodatkeZaprijavo(accessToken, refreshToken, expiresOn);
      }
      return user;
    }catch (e){
      print(e);
      return null;
    }
}

Future<void> shraniUporabnikovePodatkeZaprijavo(accessToken,refreshToken,expiresOn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(keyForAccessToken, accessToken);
  prefs.setString(keyForRefreshToken, refreshToken);
  prefs.setString(keyForExpiresOn, expiresOn);
  print("Uporabnik shranjen");
}

Future<bool> aliJeUporabnikPrijavljen(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try{
    final accessToken = prefs.getString(keyForAccessToken);
    final refreshToken = prefs.getString(keyForRefreshToken);
    final expiresOn = prefs.getString(keyForRefreshToken);
    if(accessToken != null && accessToken != ""){
      print("Uporabnik obstaja.");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }catch (e){
    return false;
  }
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