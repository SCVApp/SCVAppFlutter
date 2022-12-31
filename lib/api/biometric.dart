import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scv_app/global/global.dart' as global;

class Biometric {
  bool locked = false;
  bool biometric = false;
  static final Map<int, String> autoLockModes = {
    0: "Takoj",
    1: "1 minuta",
    2: "5 minut",
    3: "10 minut",
    4: "15 minut",
    5: "30 minut"
  };

  static final Map<int, int> autoLockModeValues = {
    0: 0,
    1: 1,
    2: 5,
    3: 10,
    4: 15,
    5: 30
  };

  DateTime lastActivity = DateTime.now();

  static final String biometricKey = "SCVApp-key-biometric";

  int autoLockMode = 0;

  Biometic() {
    this.locked = false;
    this.biometric = false;
    this.autoLockMode = 0;
  }

  void fromJson(Map<String, dynamic> json) {
    this.biometric = json['biometric'];
    this.autoLockMode = json['autoLockMode'];
    this.lastActivity = DateTime.parse(json['lastActivity']);
  }

  Map<String, dynamic> toJson() {
    return {
      'lastActivity': this.lastActivity.toString(),
      'biometric': this.biometric,
      'autoLockMode': this.autoLockMode,
    };
  }

  Future<void> save() async {
    final FlutterSecureStorage storage = global.token.storage;
    await storage.write(key: biometricKey, value: jsonEncode(this.toJson()));
  }

  Future<void> load() async {
    final FlutterSecureStorage storage = global.token.storage;
    try {
      String json = await storage.read(key: biometricKey);
      this.fromJson(jsonDecode(json));
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete() async {
    final FlutterSecureStorage storage = global.token.storage;
    await storage.delete(key: biometricKey);
  }

  Future<void> updateLastActivity() async {
    this.lastActivity = DateTime.now();
    await this.save();
  }

  void showLockScreen({bool fromBackground = false}) {
    if (this.biometric == false) {
      return;
    }
    if (fromBackground == true) {
      DateTime now = DateTime.now();
      Duration diff = now.difference(this.lastActivity);
      int minutes = diff.inMinutes;
      if (minutes >= autoLockModeValues[this.autoLockMode]) {
        this.locked = true;
      }
    } else {
      this.locked = true;
    }
  }

  Future<void> turnOffBiometric() async {
    this.biometric = false;
    await this.save();
  }

  Future<void> turnOnBiometric() async {
    this.biometric = true;
    await this.save();
  }

  Future<void> setAutoLockMode(int mode) async {
    this.autoLockMode = mode;
    await this.save();
  }

  String displayName() {
    if(biometric == true) {
      return "Vklopljeno";
    } else {
      return "Izklopljeno";
    }
  }
}
