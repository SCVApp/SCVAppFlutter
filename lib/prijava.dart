import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:scv_app/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

// final String apiUrl = "http://localhost:5050";
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
}

class Token{
  final String accessToken;
  final String refreshToken;
  final String expiresOn;

  Token(this.accessToken,this.refreshToken,this.expiresOn);
  Token.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        expiresOn = json['expiresOn'];

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresOn': expiresOn,
      };

}
Future<String> refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString(keyForAccessToken);
  final refreshToken = prefs.getString(keyForRefreshToken);
  final expiresOn = prefs.getString(keyForExpiresOn);

  Token oldToken = new Token(accessToken, refreshToken, expiresOn);
  final respons = await http.post("$apiUrl/auth/refreshToken/",body: oldToken.toJson());
  if(respons.statusCode == 200){
    Token newToken = new Token.fromJson(jsonDecode(respons.body));
    prefs.setString(keyForAccessToken, newToken.accessToken);
    prefs.setString(keyForRefreshToken, newToken.refreshToken);
    prefs.setString(keyForExpiresOn, newToken.expiresOn);
 
    return newToken.accessToken;
  }else{
    prefs.remove(keyForAccessToken);
    prefs.remove(keyForRefreshToken);
    prefs.remove(keyForExpiresOn);
    print("Error");
    return "";
  }
}

Future<bool> aliJeUporabnikPrijavljen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try{
    final accessToken = prefs.getString(keyForAccessToken);
    final refreshToken = prefs.getString(keyForRefreshToken);
    final expiresOn = prefs.getString(keyForExpiresOn);
    if(accessToken != null && accessToken != ""){
      return true;
    }
    return false;
  }catch (e){
    return false;
  }
}

Future<UserData> fetchUserData(String token) async {
  final response = await http
      .get(Uri.parse('$apiUrl/user/get'),headers: {"Authorization":token});

  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    UserData user = UserData(decoded['displayName'],decoded['givenName'],decoded['surname'], decoded['mail'], decoded['mobilePhone'], decoded['id'], decoded['userPrincipalName']);
    return user;
  } else {
    return null;
  }

}