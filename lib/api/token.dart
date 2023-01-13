import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;
import 'package:intl/intl.dart';

class Token {
  String accessToken;
  String refreshToken;
  String expiresOn;
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Token(
      {this.accessToken = "", this.refreshToken = "", this.expiresOn = null}) {
    if (accessToken == "" && refreshToken == "" && expiresOn == null) {
      loadToken();
    }
  }

  String accessTokenKey = "SCVApp-key-access-token";
  String refreshTokenKey = "SCVApp-key-refresh-token";
  String expiresKey = "SCVApp-key-expires-on";

  Future<void> saveToken() async {
    await storage.write(key: accessTokenKey, value: accessToken);
    await storage.write(key: refreshTokenKey, value: refreshToken);
    await storage.write(key: expiresKey, value: expiresOn.toString());
  }

  Future<void> loadToken() async {
    try {
      accessToken = await storage.read(key: accessTokenKey);
      refreshToken = await storage.read(key: refreshTokenKey);
      expiresOn = await storage.read(key: expiresKey);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteToken() async {
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
    await storage.delete(key: expiresKey);
  }

  Map<String, dynamic> toJSON() {
    return {
      'accessToken': this.accessToken,
      'refreshToken': this.refreshToken,
      'expiresOn': this.expiresOn,
    };
  }

  void fromJSON(Map<String, dynamic> json) {
    this.accessToken = json['accessToken'];
    this.refreshToken = json['refreshToken'];
    this.expiresOn = json['expiresOn'];
  }

  Future<void> refresh({int depth = 0}) async {
    try {
      DateTime expires = new DateFormat("EEE MMM dd yyyy hh:mm:ss")
          .parse(this.expiresOn)
          .toUtc()
          .subtract(Duration(minutes: 3));
      if (expires.isBefore(DateTime.now().toUtc())) {
        final respons = await http.post(
            Uri.parse("${global.apiUrl}/auth/refreshToken/"),
            body: this.toJSON());
        if (respons.statusCode == 200) {
          this.fromJSON(jsonDecode(respons.body));
          await this.saveToken();
        } else {
          throw Exception('Failed to refresh token');
        }
      }
    } catch (e) {
      //Check if date is not parsable
      if (e is FormatException) {
        return;
      }
      if (depth == 0) {
        global.showGlobalAlert(text: "Napaka pri osveževanju podatkov");
      }
      if (depth >= 5) {
        global.showGlobalAlert(
            text: "Napaka pri osveževanju podatkov",
            action: TextButton(
                onPressed: () async {
                  global.logOutUser(global.globalBuildContext);
                },
                child: Text("Odjava")),
            duration: 10);
      } else {
        await Future.delayed(Duration(seconds: 7));
        await this.refresh(depth: depth + 1);
      }
    }
  }
}
