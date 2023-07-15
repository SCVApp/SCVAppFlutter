import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

enum AppThemeType { Light, Dark, System }

class AppTheme {
  AppThemeType type = AppThemeType.System;

  AppTheme(){
    this.type = AppThemeType.System;
  }

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? typeString = prefs.getString('theme');
    if (typeString == null) {
      this.type = AppThemeType.System;
    } else {
      this.type = AppThemeType.values.firstWhere((AppThemeType type) {
        return type.toString() == typeString;
      });
    }
    this.setTo();
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', this.type.toString());
  }

  Future<void> delete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme');
  }

  void changeTheme(AppThemeType type) {
    this.type = type;
    this.save();
    this.setTo();
  }

  void setTo() {
    switch (this.type) {
      case AppThemeType.Light:
        changeToLightTheme();
        break;
      case AppThemeType.Dark:
        changeToDarkTheme();
        break;
      case AppThemeType.System:
        changeToSystemTheme();
        break;
    }
  }

  static void changeToSystemTheme() {
    Get.changeThemeMode(ThemeMode.system);
  }

  static void changeToLightTheme() {
    Get.changeThemeMode(ThemeMode.light);
  }

  static void changeToDarkTheme() {
    Get.changeThemeMode(ThemeMode.dark);
  }

  String displayName() {
    switch (this.type) {
      case AppThemeType.Light:
        return 'Svetli način';
      case AppThemeType.Dark:
        return 'Temni način';
      case AppThemeType.System:
        return 'Sistemsko';
    }
    return '';
  }
}
