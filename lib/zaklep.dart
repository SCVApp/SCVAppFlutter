import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/main.dart';
import 'package:scv_app/nastavitve.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/urnik.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:scv_app/api/local_auth_api.dart';

class ZaklepPage extends StatefulWidget {
  ZaklepPage({Key key, this.isFromAutoLock = false}) : super(key: key);

  final bool isFromAutoLock;
  _ZaklepPageState createState() => _ZaklepPageState();
}

class _ZaklepPageState extends State<ZaklepPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  bool _authorizedOrNot = true;
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
        options: AuthenticationOptions(useErrorDialogs: true,stickyAuth: true)
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = true;
        if(!widget.isFromAutoLock){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        }else{
          Navigator.pop(context);
        }
      } else {
        _authorizedOrNot = false;
      }
    });
  }

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();
    onStartUp();
  }

  void onStartUp() async{
    await _checkBiometric();
    if(_canCheckBiometric){
      await _authorizeNow();
    }
  }

  bool _value = true;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: SafeArea(
      child: !_authorizedOrNot
          ? Column(
              children: [
                ElevatedButton(
                    child: Icon(Icons.error_outline),
                    onPressed: () {
                      _authorizeNow();
                    })
              ],
            )
          : Text(""),
    ));
  }
}
