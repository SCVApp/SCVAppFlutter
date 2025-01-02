import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Token {
  String? accessToken;
  String? refreshToken;
  String? expiresOn;
  String? notificationToken;
  String? deviceId;
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String publicKey =
      "-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwuYUBLI1w19N3LG8nMt9kpmI/un0jToxDUZMIfRsL93u2vi4gR/UZ1vUlYdxJE6YObCsZRImrXoS5ZZr469L1Iua3FvfdZS1HpSNc5l0Vi4Ui/NFDYxGfcmPXYGsgc5Hoe1rYh0H9Z7FQuldVLIY06vPmf+qWCoOonHtizJke61wsXBOPO0Wriy54yJRtPtZMCO0xcovAiQJ18xSb8MpY0OI1bKAfLsv3/PqAKutkKoSZ/JsE1d7HMgjdXoL2gqb7bWdNqEdW2uwDbRLFCm/GAk6GQt4QlxkTFnG/pSIX0bRo8NCEXZ2HtmAIxN3bWNJ0gCR62aULJWzRSTtW0DDUMiOfDnYo/M/ljOtP72FcF9poOcB+ZQSXslI15NVXm8iN94yTcO3Ke0a12BTso2gOwrCLecoGrozDDpOQzOWRp/JI3GgDvkNALvFVgqqk1iYArcW/5q/l/Z4dE3yywKESNM7yxWIFwkYO5Rq4XK52GuGEgKpyk1TjZYzA7MfsSBkU/NNbzB8JpxeSOhzXEB4SUl4yRxRRlfFxkhkTbM5IBi46oJXyQo6+JLu+QqoXkdjxQGRsA2F7SVMukiAuhvf6fp0aipYJ3UZZuQHT7g8FfCcXP4xV1PYpdpXT9gqNMtI7WOErlI/QB0JwXT6ezbM+aI9SL7+pVB1UOLGvDcPNXcCAwEAAQ==\n-----END PUBLIC KEY-----";

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

  String getAccessToken() {
    return this.accessToken ?? "";
  }

  Future<void> loadToken() async {
    try {
      accessToken = await storage.read(key: accessTokenKey);
      refreshToken = await storage.read(key: refreshTokenKey);
      expiresOn = await storage.read(key: expiresKey);
      chechTokens();
      notificationToken = await messaging.getToken();
      deviceId = await getDeviceId() ?? '';
    } catch (e) {
      print(e);
    }
  }

  void chechTokens() {
    if (refreshToken != null) {
      try {
        JWT.verify(refreshToken!, RSAPublicKey(publicKey));
      } catch (e) {
        print(e);
        accessToken = null;
        expiresOn = null;
        refreshToken = null;
      }
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
      'notificationToken': this.notificationToken,
      'deviceId': this.deviceId
    };
  }

  void fromJSON(Map<String, dynamic> json) {
    try {
      this.accessToken = json['accessToken'];
      this.refreshToken = json['refreshToken'];
      this.expiresOn = json['expiresOn'];
    } catch (e) {}
  }

  bool isExpired() {
    if (this.accessToken == null) {
      return true;
    }
    try {
      JWT.verify(accessToken!, RSAPublicKey(publicKey));
    } catch (e) {
      return true;
    }
    return false;
  }

  Future<void> refresh({int depth = 0, bool force = false}) async {
    if (!(await global.canConnectToNetwork())) {
      return;
    }
    try {
      DateTime expires = new DateFormat("EEE MMM dd yyyy hh:mm:ss")
          .parse(this.expiresOn ?? "")
          .toUtc()
          .subtract(Duration(minutes: 3));
      if (expires.isBefore(DateTime.now().toUtc()) || isExpired() || force) {
        final respons = await http.post(
            Uri.parse("${global.apiUrl}/auth/refreshToken/"),
            body: this.toJSON());
        if (respons.statusCode == 200) {
          this.fromJSON(jsonDecode(respons.body));
          await this.saveToken();
        } else if (respons.statusCode == 402) {
          throw Exception('402');
        } else {
          throw Exception('Failed to refresh token');
        }
      }
    } catch (e) {
      if (e is FormatException) {
        return;
      }
      final bool is402Error = e.toString() == 'Exception: 402';
      if (!is402Error) {
        if (!(await global.canConnectToNetwork())) {
          return;
        }
      }
      if (depth >= 3 && is402Error) {
        global.showGlobalAlert(
            text: "Napaka pri osveževanju podatkov",
            action: TextButton(
                onPressed: () async {
                  global.logOutUser(global.globalBuildContext);
                },
                child: Text("Odjava")),
            duration: 10);
      } else {
        await Future.delayed(Duration(seconds: is402Error ? 5 : 10));
        if (depth < 10) {
          await this.refresh(depth: depth + 1);
        }
      }
    }
  }

  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  Future<void> removeNotificationToken() async {
    try {
      final Uri uri = Uri.parse("${global.apiUrl}/auth/logout");
      final Map<String, String> headers = {
        "Authorization": "${this.getAccessToken()}"
      };
      final Map<String, String> body = {
        "notificationToken": this.notificationToken ?? "",
      };
      final http.Response response =
          await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        this.notificationToken = null;
      }
    } catch (e) {
      print("Error in removeNotificationToken: $e");
    }
  }
}
