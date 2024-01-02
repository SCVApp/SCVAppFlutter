import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:scv_app/components/nastavitve/biomatricPage/biometricAlert.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Biometric {
  bool locked = false;
  bool biometric = false;
  static final Map<int, String> autoLockModes = {
    0: AppLocalizations.of(global.globalBuildContext)!.instant_lock,
    1: AppLocalizations.of(global.globalBuildContext)!.one_minute,
    2: "5 ${AppLocalizations.of(global.globalBuildContext)!.five_or_more_minutes}",
    3: "10 ${AppLocalizations.of(global.globalBuildContext)!.five_or_more_minutes}",
    4: "15 ${AppLocalizations.of(global.globalBuildContext)!.five_or_more_minutes}",
    5: "30 ${AppLocalizations.of(global.globalBuildContext)!.five_or_more_minutes}"
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

  bool isPaused = false;

  static final LocalAuthentication localAuthentication = LocalAuthentication();

  Biometic() {
    this.locked = false;
    this.biometric = false;
    this.autoLockMode = 0;
  }

  void fromJson(Map<String, dynamic> json) {
    this.biometric = json['biometric'];
    this.autoLockMode = json['autoLockMode'];
    this.lastActivity = DateTime.parse(json['lastActivity']);
    this.isPaused = json['isPaused'];
  }

  Map<String, dynamic> toJson() {
    return {
      'lastActivity': this.lastActivity.toString(),
      'biometric': this.biometric,
      'autoLockMode': this.autoLockMode,
      'isPaused': this.isPaused
    };
  }

  Future<void> save() async {
    final FlutterSecureStorage storage = global.token.storage;
    await storage.write(key: biometricKey, value: jsonEncode(this.toJson()));
  }

  Future<void> load() async {
    final FlutterSecureStorage storage = global.token.storage;
    try {
      String? json = await storage.read(key: biometricKey);
      if (json == null) {
        return;
      }
      this.fromJson(jsonDecode(json));
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete() async {
    final FlutterSecureStorage storage = global.token.storage;
    await storage.delete(key: biometricKey);
    this.biometric = false;
    this.autoLockMode = 0;
    this.lastActivity = DateTime.now();
    this.isPaused = false;
    this.locked = false;
  }

  Future<void> updateLastActivity({bool isPaused = false}) async {
    this.lastActivity = DateTime.now();
    this.isPaused = isPaused;
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
      if (minutes >= autoLockModeValues[this.autoLockMode]!) {
        this.locked = true;
      }
    } else {
      this.locked = true;
    }
  }

  Future<void> setBiometric(bool value) async {
    this.biometric = value;
    if (value == false) {
      this.locked = false;
    }
    await this.save();
  }

  Future<void> setAutoLockMode(int mode) async {
    this.autoLockMode = mode;
    await this.save();
  }

  String displayName() {
    if (biometric == true) {
      return "Vklopljeno";
    } else {
      return "Izklopljeno";
    }
  }

  Future<bool> authenticate(BuildContext context,
      {List<Widget>? actions, String? text}) async {
    bool authenticated = false;
    try {
      authenticated = await localAuthentication.authenticate(
          localizedReason: "Prijavite se z biometrično varnostjo",
          options:
              AuthenticationOptions(stickyAuth: true, useErrorDialogs: true));
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "NotAvailable" &&
            e.message == "Required security features not enabled") {
          await biometricAlert(context, actions: actions, text: text);
        }
      }
    }
    return authenticated;
  }

  Future<void> unlock(BuildContext context,
      {List<Widget>? actions, String? text}) async {
    if (await this.authenticate(context, actions: actions, text: text) ==
        true) {
      this.locked = false;
    }
  }
}
