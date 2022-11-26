import 'package:flutter/material.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

enum ThemeEnum { system, light, dark }

class UseTheme {
  static Future<ThemeEnum> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool isDarkTheme = prefs.getBool(keyForThemeDark);
      if (isDarkTheme == null) {
        return ThemeEnum.system;
      } else if (isDarkTheme == true) {
        return ThemeEnum.dark;
      } else {
        return ThemeEnum.light;
      }
    } catch (e) {
      return ThemeEnum.system;
    }
  }

  static Future<void> handleChanged(ThemeEnum value) async {
    switch (value) {
      case ThemeEnum.system:
        await changeToSystemTheme();
        break;
      case ThemeEnum.light:
        await changeToLightTheme();
        break;
      case ThemeEnum.dark:
        await changeToDarkTheme();
        break;
    }
  }

  static Future<void> changeToSystemTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.changeThemeMode(ThemeMode.system);
    prefs.remove(keyForThemeDark);
  }

  static Future<void> changeToLightTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.changeThemeMode(ThemeMode.light);
    prefs.setBool(keyForThemeDark, false);
  }

  static Future<void> changeToDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.changeThemeMode(ThemeMode.dark);
    prefs.setBool(keyForThemeDark, true);
  }

  static String getNameOfTheme(ThemeEnum value) {
    switch (value) {
      case ThemeEnum.system:
        return "Sistemsko";
      case ThemeEnum.light:
        return "Svetli način";
      case ThemeEnum.dark:
        return "Temni način";
    }
  }
}
