import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Components/settingsUserCard.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/backBtn.dart';
import '../data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Components/nastavitveGroup.dart';
import 'package:scv_app/Components/settingsUserCard.dart';
import 'package:scv_app/SettingsPages/aboutAplication.dart';
import 'package:scv_app/SettingsPages/aboutMe.dart';
import 'package:scv_app/SettingsPages/biometricPage.dart';
import 'package:scv_app/SettingsPages/changeStatus.dart';
import 'package:scv_app/SettingsPages/otherToolsPage.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/theme.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';


class AboutMePage extends StatefulWidget {
  AboutMePage({Key key, this.data}) : super(key: key);

  final Data data;

  _AboutMePage createState() => _AboutMePage();
}

class _AboutMePage extends State<AboutMePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();
    loadToken();
  }

    bool jeSistemskaTema = false;
  bool isBioEnabled = false;
  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        token = prefs.getString(keyForAccessToken);
      });
    } catch (e) {
      print(e);
    }
    try {
      bool test = prefs.getBool(keyForThemeDark);
      if (test == null) {
        setState(() {
          jeSistemskaTema = true;
        });
      }
    } catch (e) {
      print(e);
    }
    try {
      bool test = prefs.getBool(keyForUseBiometrics);
      if (test != null) {
        setState(() {
          isBioEnabled = test;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool _value = Get.isDarkMode;

  toggleThemeBtn(toggle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = toggle;
    });
    if (!toggle) {
      Get.changeThemeMode(ThemeMode.light);
      prefs.setBool(keyForThemeDark, false);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      prefs.setBool(keyForThemeDark, true);
    }
    setState(() {
      jeSistemskaTema = false;
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              backButton(context),
              SettingsUserCard(
                userName: widget.data.user!=null ? widget.data.user.displayName:"",
                // userName: "",
                userProfilePic: widget.data.user!=null ? widget.data.user.image:AssetImage("asstes/profilePicture.png"),
                cardColor: widget.data.schoolData.schoolColor,
                userMoreInfo: Text(
                  widget.data.user != null ? widget.data.user.mail:"",
                  style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height/42 > 14 ? 14 : MediaQuery.of(context).size.height/42),
                ),
                data: widget.data,
              ),
            ],
          ),
        )
    );
  }
}