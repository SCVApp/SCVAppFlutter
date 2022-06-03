import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';
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
import 'package:app_settings/app_settings.dart';

class BiometricPage extends StatefulWidget {
  final Function() notifyParent;
  BiometricPage({Key key, this.data, @required this.notifyParent})
      : super(key: key);

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
      canCheckBiometric = await _localAuthentication.isDeviceSupported();
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
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not Authorized";
      }
    });
  }

  Future<void> _OpozoriloBiometrika() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opozorilo!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('V telefonu nimaš nastavljenih varnostnih nastavitev.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Prekliči'),
                onPressed: () => Navigator.pop(context, 'Cancel')),
            TextButton(
                child: const Text('Odpri nastavitve',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => AppSettings.openSecuritySettings()),
          ],
        );
      },
    );
  }

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();

    loadPrefs();
  }

  void loadPrefs() async {
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

    try{
      int timeInMinutes = prefs.getInt(keyForAppAutoLockTimer);
      if(timeInMinutes != null){
        int izbira = 1;
        if(timeInMinutes == 0){
          izbira = 0;
        }else if(timeInMinutes == 5){
          izbira = 1;
        }else if(timeInMinutes == 10){
          izbira = 2;
        }else if(timeInMinutes == 30){
          izbira = 3;
        }else{
          izbira = 4;
        }
        setState(() {
          selectedAutoLockItem = izbira;
        });
      }
    }catch(e){
      print(e);
    }
  }

  bool _value = false;

  int selectedAutoLockItem = 1;

  changeToggle(bool toggle) async {
    await _checkBiometric();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_canCheckBiometric) {
      setState(() {
        _value = !_value;
      });
      prefs.setBool(keyForUseBiometrics, _value);
      widget.notifyParent();
    } else {
      prefs.setBool(keyForUseBiometrics, false);
      setState(() {
        _value = false;
      });
      _OpozoriloBiometrika();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          backButton(context),
          Container(
              width: 200,
              height: 150,
              child: Image.asset(
                'assets/biometrika.gif',
              )),
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
              Switch.adaptive(
                value: _value,
                onChanged: changeToggle,
              ),
              Text(
                  "Biometrično odlepanje: ${_value ? "Omogočeno" : "Onemogočeno"}"),
              _value?ListTile(title:Text("Zaklep aplikacije v odzadju: " + autoLockMods[selectedAutoLockItem].toString()), onTap: (){
                showPicker(context);
              }):SizedBox()
            ],
          )
        ],
      ),
    ));
  }

  List<String> autoLockMods = [
    "Takoj",
    "Po 5 minutah",
    "Po 10 minutah",
    "Po 30 minutah",
    "Nikoli",
  ];

  createPickerItems(){
    return autoLockMods.map((e) => new PickerItem(text: new Text(e), value: autoLockMods.indexOf(e))
    ).toList();
  }

  showPicker(BuildContext context){
    Picker picker = new Picker(adapter: PickerDataAdapter(data: createPickerItems()), onConfirm: selectAutoLock, selecteds: [selectedAutoLockItem]);
    picker.showModal(context);
  }

  selectAutoLock(Picker picker, List value) async {
    if(value.length > 0){
      int newValue = value[0];
      setState(() {
        selectedAutoLockItem = newValue;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int timeInMinutes = 0;
      if(newValue == 1){
        timeInMinutes = 5;
      }else if(newValue == 2){
        timeInMinutes = 10;
      }else if(newValue == 3){
        timeInMinutes = 30;
      }else if(newValue == 4){
        timeInMinutes = 10001;
      }
      prefs.setInt(keyForAppAutoLockTimer, timeInMinutes);
    }
  }

}
