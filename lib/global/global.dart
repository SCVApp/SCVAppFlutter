import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/alert.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/token.dart';
import 'package:get/get.dart';

final Token token = new Token();

BuildContext globalBuildContext;

// final String apiUrl = "http://10.0.2.2:5050";
final String apiUrl = "https://backend.app.scv.si";

final String appVersion = "2.2.1";

Connectivity connectivity = new Connectivity();

Future<void> logOutUser(BuildContext context) async {
  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    Get.changeThemeMode(ThemeMode.dark);
  } else {
    Get.changeThemeMode(ThemeMode.light);
  }
  await CookieManager().clearCookies();
  await token.deleteToken();
  User user = StoreProvider.of<AppState>(globalBuildContext).state.user;
  user.loggedIn = false;
  StoreProvider.of<AppState>(globalBuildContext).dispatch(user);
}

void showGlobalAlert(
    {String text = "", Widget action, int duration = 3, IconData icon}) {
  if (globalBuildContext != null) {
    GlobalAlert globalAlert =
        StoreProvider.of<AppState>(globalBuildContext).state.globalAlert;
    if (globalAlert.show(text, action, icon)) {
      Future.delayed(Duration(seconds: duration), () {
        globalAlert.hide();
        StoreProvider.of<AppState>(globalBuildContext).dispatch(globalAlert);
      });
    }
    StoreProvider.of<AppState>(globalBuildContext).dispatch(globalAlert);
  }
}

// Path: lib/global/global.dart