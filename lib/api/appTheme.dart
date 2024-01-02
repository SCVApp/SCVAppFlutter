import 'package:flutter/material.dart';
import 'package:scv_app/global/global.dart';
import 'package:scv_app/theme/Themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

enum AppThemeType { Light, Dark, System }

class AppTheme {
  AppThemeType type = AppThemeType.System;
  ColorScheme colorScheme = ColorScheme.light();

  AppTheme() {
    this.type = AppThemeType.System;
  }

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? typeString = prefs.getString('theme');
    if (typeString == null) {
      this.type = AppThemeType.System;
    } else {
      this.type = AppThemeType.values.firstWhereOrNull((AppThemeType type) {
            return type.toString() == typeString;
          }) ??
          AppThemeType.System;
    }
    this.setTo();
  }

  void setColorScheme(ColorScheme colorScheme) {
    this.colorScheme = colorScheme;
    this.applyColorScheme();
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

  void changeToSystemTheme() {
    Get.changeThemeMode(ThemeMode.system);
  }

  void changeToLightTheme() {
    Get.changeThemeMode(ThemeMode.light);
  }

  void changeToDarkTheme() {
    Get.changeThemeMode(ThemeMode.dark);
  }

  void applyColorScheme() {
    if (!globalBuildContext.mounted) {
      return;
    }
    final ThemeData themeDataLight = Themes.light.copyWith(
      colorScheme: colorScheme,
    );
    Get.changeTheme(themeDataLight);
  }

  String displayName() {
    switch (this.type) {
      case AppThemeType.Light:
        return 'Svetli način';
      case AppThemeType.Dark:
        return 'Temni način';
      case AppThemeType.System:
        return 'Sistemsko';
      default:
        return '';
    }
  }
}
