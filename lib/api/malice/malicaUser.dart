import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/malice/malica.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:scv_app/store/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MalicaUser {
  String accessToken = "";
  bool enabled = true;

  bool isLoggedIn() {
    if (accessToken == "") return false;
    try {
      final token = JWT.decode(accessToken);
      return int.parse(token.payload["exp"].toString()) * 1000 >
          DateTime.now().millisecondsSinceEpoch;
    } catch (e) {
      return false;
    }
  }

  Future<String> getMicrosoftAccessToken() async {
    if (global.token.isExpired()) {
      await global.token.refresh();
    }
    try {
      JWT json = JWT.decode(global.token.getAccessToken());
      return json.payload["accessToken"];
    } catch (e) {
      return "";
    }
  }

  void fromJson(Map<String, dynamic> json) {
    try {
      if (json["access_token"] != null) {
        this.accessToken = json["access_token"];
      }
      if (json["enabled"] != null) {
        this.enabled = json["enabled"];
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "enabled": this.enabled,
      "access_token": this.accessToken,
    };
  }

  Future<void> save() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("malicaUser", jsonEncode(this.toJson()));
      global.malicaAccessToken = this.accessToken;
    } catch (e) {}
  }

  Future<void> load() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String malicaUserJson = prefs.getString("malicaUser") ?? "";
      if (malicaUserJson == "") {
        return;
      }
      final Map<String, dynamic> json = jsonDecode(malicaUserJson);
      this.fromJson(json);
      global.malicaAccessToken = this.accessToken;
    } catch (e) {}
  }

  Future<void> loadDataFromWeb() async {
    final String url = Malica.apiURL + "/user";
    try {
      final response = await http.get(Uri.parse(url),
          headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        this.fromJson(json);
        await save();
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      accessToken = "";
    }
  }

  Future<void> loginWithMicrosoftToken() async {
    final String microsoftAccessToken = await getMicrosoftAccessToken();
    if (microsoftAccessToken == "") {
      return;
    }
    final String url = Malica.apiURL + "/auth/microsoft";
    try {
      final response = await http.post(Uri.parse(url), body: {
        "microsoft_auth_token": microsoftAccessToken,
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        this.fromJson(json);
        await save();
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      accessToken = "";
    }
  }

  Future<void> logout() async {
    accessToken = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("malicaUser");
  }

  static Future<void> toggleEnable(BuildContext context, bool enabled) async {
    final Malica malica = StoreProvider.of<AppState>(context).state.malica;
    malica.maliceUser.enabled = enabled;
    await malica.maliceUser.save();
    StoreProvider.of<AppState>(context).dispatch(malica);
  }
}
