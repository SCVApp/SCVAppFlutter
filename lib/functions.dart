import 'package:flutter/material.dart';
import 'package:scv_app/data.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

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
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnBoardingPage()));
}
