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
      "-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAkPdF2W7SpSTm5oaaMPynOdiBB2L62UY+bX+prOZp4yWiDk7/Bo2NPbZcVAUT+fhp417zfPmdkxHaO5wqcQ926EMXmWyM/DHxPm/O/le/h+gY/TOAyd3zY3nu5QylINf2PApavMkN8jEOQ3YglwQdGmjXErDKmX67JSCADybbOoNkELthinW1tza8627KAj9oDEtq5dvrBXQvMPFat2XiVis34Kay0Sk12PNRrxPv0FXbA1wlwNlytAnAfnrGYjslRVwI1PMRSOamgpVZwUs3ujKu0hM0+RWQb2U8ndlwwHQEGK0Xl98CSdySI9rFdYulYnmvtARS/hvuo8Y70jIP1+tRk6+Q101HKKm9N3AAzp1gKkCXOypqSiW3+sAV637biNnUS4RK4L6CX1FoEkkUWJBqtH2ExdYBtZahfuaAfyfZ3qg+/+mMf0k2FCEnErOxKoxXZwNfW7KBHW+TYFfxiZX8rzQ6KXSefKLJDeU+nJoKTmlp6gIKMt2epN0UmAGb97Ed1YeekETrzCitq+Rau+4/TRXLCqjqGcCkP2BmyhuwQ9bSt/DoL9IWDfmWHjtkJ95GORjBTXNDgGZawcjBNKpbNicxQ6hMAmpzyMwABlsMv6pAemY+LzKYKnr4I8LjWDdbRfNbjMq5EkskrnWrwPeDtKs14VuM9q3ZwYQWOpMCAwEAAQ==\n-----END PUBLIC KEY-----";

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
