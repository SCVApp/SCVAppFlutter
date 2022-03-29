import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/nastavitve.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/urnik.dart';
import 'package:scv_app/uvod.dart';
import 'package:scv_app/zaklep.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/backBtn.dart';
import '../data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:scv_app/api/local_auth_api.dart';

class BiometricPage extends StatefulWidget {
  final Function() notifyParent;
  BiometricPage({Key key, this.data,@required this.notifyParent}) : super(key: key);

  final Data data;

  _BiometricPage createState() => _BiometricPage();
}

class _BiometricPage extends State<BiometricPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticate(
        localizedReason: "Za vstop se autoriziraj:",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not Authorized";
      }
    });
  }

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();

    loadPrefs();
  }

  void loadPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool test = prefs.getBool(keyForUseBiometrics);
      if (test != null) {
        setState(() {
          _value = test;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool _value = false;

  changeToggle(bool toggle) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = !_value;
    });
    prefs.setBool(keyForUseBiometrics, _value);
    widget.notifyParent();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          backButton(context),
          // ElevatedButton(
          //     child: Icon(Icons.abc),
          //     onPressed: () {
          //       _checkBiometric();
          //       _authorizeNow();
          //     }),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Switch.adaptive(value: _value,onChanged: changeToggle,),
              Text("Biometrično odlepanje: ${_value?"Omogočeno":"Onemogočeno"}"),
            ],
          )
        ],
      ),
    ));
  }
}
