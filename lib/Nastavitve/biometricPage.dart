import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/backBtn.dart';
import '../Data/data.dart';
import 'package:local_auth/local_auth.dart';
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
  List<BiometricType> _availableBiometricTypes = List<BiometricType>.empty();

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
          options:
              AuthenticationOptions(useErrorDialogs: true, stickyAuth: true));
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

    try {
      int timeInMinutes = prefs.getInt(keyForAppAutoLockTimer);
      if (timeInMinutes != null) {
        int izbira = 1;
        if (timeInMinutes == 0) {
          izbira = 0;
        } else if (timeInMinutes == 5) {
          izbira = 1;
        } else if (timeInMinutes == 10) {
          izbira = 2;
        } else if (timeInMinutes == 30) {
          izbira = 3;
        } else {
          izbira = 4;
        }
        setState(() {
          selectedAutoLockItem = izbira;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool _value = false;

  int selectedAutoLockItem = 0;

  changeToggle(bool toggle) async {
    await _checkBiometric();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_canCheckBiometric) {
      setState(() {
        _value = !_value;
      });
      prefs.setBool(keyForUseBiometrics, _value);
      widget.notifyParent();
      if (_value == true) {
        defualtSelectAutoLock(prefs);
      }
    } else {
      prefs.setBool(keyForUseBiometrics, false);
      setState(() {
        _value = false;
      });
      _OpozoriloBiometrika();
    }
  }

  defualtSelectAutoLock(SharedPreferences prefs) {
    try {
      int autoLockTimer = prefs.getInt(keyForAppAutoLockTimer);
      if (autoLockTimer == null) {
        prefs.setInt(keyForAppAutoLockTimer, 0);
        print("Auto lock prefs set automatically");
      }
    } catch (e) {
      prefs.setInt(keyForAppAutoLockTimer, 0);
      print("Auto lock prefs set automatically");
    }
  }

  Widget build(BuildContext context) {
    double textSize = min(MediaQuery.of(context).size.width * 0.042, 16);
    TextStyle textStyle = TextStyle(
      fontSize: textSize,
      color: Theme.of(context).primaryColor,
    );

    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          backButton(context),
          Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Biometrični odklep aplikacije", style: textStyle),
                    SizedBox(
                      child: CupertinoSwitch(
                        value: _value,
                        onChanged: changeToggle,
                      ),
                      width: 45,
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                _value
                    ? GestureDetector(
                        child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Zaklep aplikacije v ozadju po:",
                                style: textStyle,
                              ),
                              Text(
                                autoLockMods[selectedAutoLockItem].toString(),
                                style: textStyle,
                              )
                            ]),
                        onTap: () {
                          showPicker(context);
                        })
                    : SizedBox(),
                Padding(padding: EdgeInsets.only(top: 60)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("INFO",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: textSize,
                            fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      "Z omogočanjem te nastavite lahko nato v aplikacijo vstopite preko biometričnih podatkov (prepoznava obraza ali Face ID, prepoznava prstnega odtisa ali Touch ID ter PIN ali geslo telefona). V primeru, da na telefonu nimate nič od navedenega, vas aplikacija opozori, da dodate vsaj en varnostni pogoj, naveden zgoraj.",
                      style: textStyle,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                )
              ],
            ),
            padding: EdgeInsets.only(left: 30, right: 30, top: 20),
          )
        ],
      ),
    ));
  }

  List<String> autoLockMods = [
    "Takoj",
    "5 min",
    "10 min",
    "30 min",
    "Nikoli",
  ];

  createPickerItems() {
    return autoLockMods
        .map((e) =>
            new PickerItem(text: new Text(e), value: autoLockMods.indexOf(e)))
        .toList();
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter(data: createPickerItems()),
        onConfirm: selectAutoLock,
        selecteds: [selectedAutoLockItem]);
    picker.showModal(context);
  }

  selectAutoLock(Picker picker, List value) async {
    if (value.length > 0) {
      int newValue = value[0];
      setState(() {
        selectedAutoLockItem = newValue;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int timeInMinutes = 0; //Takoj
      if (newValue == 1) {
        //Zec 5 min
        timeInMinutes = 5;
      } else if (newValue == 2) {
        //Zec 10 min
        timeInMinutes = 10;
      } else if (newValue == 3) {
        //Zec 30 min
        timeInMinutes = 30;
      } else if (newValue == 4) {
        // Nikoli
        timeInMinutes = 10001;
      }
      prefs.setInt(keyForAppAutoLockTimer, timeInMinutes);
    }
  }
}
