import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/appTheme.dart';
import 'package:scv_app/components/alertContainer.dart';
import 'package:scv_app/components/backButton.dart';
import 'package:get/get.dart';

import '../../components/nastavitve/appAppearance/moonIcon.dart';
import '../../components/nastavitve/appAppearance/sunIcon.dart';
import '../../components/nastavitve/appAppearance/themeSelector.dart';
import '../../store/AppState.dart';

class AppAppearance extends StatefulWidget {
  @override
  _AppAppearanceState createState() => _AppAppearanceState();
}

class _AppAppearanceState extends State<AppAppearance> {
  void handleChanged(AppThemeType type) {
    final AppTheme appTheme =
        StoreProvider.of<AppState>(context).state.appTheme;
    appTheme.changeTheme(type);
    StoreProvider.of<AppState>(context).dispatch(appTheme);
  }

  @override
  Widget build(BuildContext context) {
    double spaceInView =
        min(60, max(MediaQuery.of(context).size.height / 15, 20));
    return StoreConnector<AppState, AppTheme>(
      converter: (store) => store.state.appTheme,
      builder: (context, appTheme) {
        return Scaffold(
          bottomSheet: AlertContainer(),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).backgroundColor == Colors.black
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: SafeArea(
              child: SingleChildScrollView(
                  child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                backButton(context),
                SizedBox(height: 20),
                Get.isDarkMode
                    ? MoonIcon(Theme.of(context).scaffoldBackgroundColor,
                        size: min(200, MediaQuery.of(context).size.width * 0.5))
                    : SunIcon(
                        size:
                            min(200, MediaQuery.of(context).size.width * 0.5)),
                SizedBox(height: spaceInView),
                Text(
                  "Izberi temo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: spaceInView),
                ThemesSelector(context, appTheme.type, handleChanged,
                    padding: 70),
              ],
            ),
          ))),
        ));
      },
    );
  }
}
