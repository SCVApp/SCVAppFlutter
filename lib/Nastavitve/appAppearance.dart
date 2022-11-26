import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Components/moonIcon.dart';
import 'package:scv_app/Components/sunIcon.dart';
import 'package:scv_app/Components/themeSelector.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:scv_app/api/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:scv_app/api/theme.dart';

class AppAppearance extends StatefulWidget {
  AppAppearance({Key key, this.onThemeChanged}) : super(key: key);
  final Function onThemeChanged;
  @override
  _AppAppearanceState createState() => _AppAppearanceState();
}

class _AppAppearanceState extends State<AppAppearance> {
  ThemeEnum appTheme = ThemeEnum.system;

  @override
  void initState() {
    super.initState();
    handleGetTheme();
  }

  Future<void> handleGetTheme() async {
    var t = await UseTheme.getTheme();
    setState(() {
      appTheme = t;
    });
  }

  void handleChanged(ThemeEnum value) async {
    setState(() {
      appTheme = value;
    });
    await UseTheme.handleChanged(value);
    widget.onThemeChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).backgroundColor == Colors.black
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                backButton(context),
                Get.isDarkMode
                    ? MoonIcon(Theme.of(context).scaffoldBackgroundColor,
                        size: min(200, MediaQuery.of(context).size.width * 0.5))
                    : SunIcon(
                        size:
                            min(200, MediaQuery.of(context).size.width * 0.5)),
                Text(
                  "Izberi temo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ThemesSelector(context, appTheme, handleChanged, padding: 70),
              ],
            )),
          )),
    );
  }
}
