import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/token.dart';
import '../api/biometric.dart';
import 'package:get/get.dart';

final Token token = new Token();

final String apiUrl = "https://backend.app.scv.si";

final String appVersion = "1.0.0";

Future<void> logOutUser(BuildContext context) async {
  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    Get.changeThemeMode(ThemeMode.dark);
  } else {
    Get.changeThemeMode(ThemeMode.light);
  }
  await CookieManager().clearCookies();
  await token.deleteToken();
}

// Path: lib/global/global.dart