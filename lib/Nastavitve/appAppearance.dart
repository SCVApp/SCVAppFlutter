import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Components/costumeRadioBtn.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

enum SingingCharacter { system, light, dark }

class AppAppearance extends StatefulWidget {
  AppAppearance({Key key, this.onThemeChanged}) : super(key: key);
  final Function onThemeChanged;
  @override
  _AppAppearanceState createState() => _AppAppearanceState();
}

class _AppAppearanceState extends State<AppAppearance> {
  SingingCharacter _character = SingingCharacter.system;

  @override
  void initState() {
    super.initState();
    handleGetTheme();
  }

  Future<void> handleGetTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool isDarkTheme = prefs.getBool(keyForThemeDark);
      if (isDarkTheme == null) {
        setState(() {
          _character = SingingCharacter.system;
        });
      } else if (isDarkTheme == true) {
        setState(() {
          _character = SingingCharacter.dark;
        });
      } else {
        setState(() {
          _character = SingingCharacter.light;
        });
      }
    } catch (e) {
      setState(() {
        _character = SingingCharacter.system;
      });
    }
  }

  void handleChanged(SingingCharacter value) async {
    setState(() {
      _character = value;
    });
    switch (value) {
      case SingingCharacter.system:
        await changeToSystemTheme();
        break;
      case SingingCharacter.light:
        await changeToLightTheme();
        break;
      case SingingCharacter.dark:
        await changeToDarkTheme();
        break;
    }
    widget.onThemeChanged();
  }

  Future<void> changeToSystemTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.changeThemeMode(ThemeMode.system);
    prefs.remove(keyForThemeDark);
  }

  Future<void> changeToLightTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.changeThemeMode(ThemeMode.light);
    prefs.setBool(keyForThemeDark, false);
    Get.changeTheme(ThemeData.light());
  }

  Future<void> changeToDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.changeThemeMode(ThemeMode.dark);
    prefs.setBool(keyForThemeDark, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).backgroundColor == Colors.black
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            backButton(context),
            CostumeRadioBtn(
                value: _character,
                type: SingingCharacter.system,
                title: "Sistemski način",
                onChanged: handleChanged),
            CostumeRadioBtn(
                value: _character,
                type: SingingCharacter.dark,
                title: "Temni način",
                onChanged: handleChanged),
            CostumeRadioBtn(
                value: _character,
                type: SingingCharacter.light,
                title: "Svetli način",
                onChanged: handleChanged),
          ],
        ),
      ),
    ));
  }
}
