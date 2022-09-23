import 'package:flutter/material.dart';
import 'package:scv_app/Data/data.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:scv_app/Intro_And__Login/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> logOutUser(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(keyForAccessToken);
  prefs.remove(keyForRefreshToken);
  prefs.remove(keyForExpiresOn);
  prefs.remove(keyForThemeDark);
  prefs.remove(keyForUseBiometrics);
  CacheData cacheData = new CacheData();
  cacheData.deleteKeys(prefs);
  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    Get.changeThemeMode(ThemeMode.dark);
  } else {
    Get.changeThemeMode(ThemeMode.light);
  }
  await CookieManager().clearCookies();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnBoardingPage()));
}

extension ListSpaceBetweenExtension on List<Widget> {
  List<Widget> withSpaceBetween({double spacing}) => [
        for (int i = 0; i < this.length; i++) ...[
          if (i > 0) Padding(padding: EdgeInsets.only(bottom: spacing)),
          this[i],
        ],
      ];
}
