import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scv_app/Data/data.dart';
import 'package:scv_app/Data/functions.dart';
import 'package:scv_app/main.dart';
import 'package:local_auth/local_auth.dart';

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

  void odjava() {
    Navigator.pop(context);
    logOutUser(context);
  }

  void pojdiVNastavitve() {
    Navigator.pop(context);
    AppSettings.openSecuritySettings();
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
                Text(
                    'V telefonu nimaš nastavljenih varnostnih nastavitev. Zato vam nemoremo odkleniti aplikacije.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Odjavi me',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => odjava()),
            TextButton(
                child: const Text('Odpri nastavitve',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => pojdiVNastavitve()),
          ],
        );
      },
    );
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticate(
          localizedReason: "Za vstop se autoriziraj",
          options:
              AuthenticationOptions(useErrorDialogs: true, stickyAuth: true));
    } on PlatformException catch (e) {
      print(e.code);
      print(e.message);
      if (e.code == "NotAvailable" &&
          e.message == "Required security features not enabled") {
        _OpozoriloBiometrika();
      }
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = true;
        if (!widget.isFromAutoLock) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        } else {
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

  void onStartUp() async {
    await _checkBiometric();
    if (_canCheckBiometric) {
      await _authorizeNow();
    } else {
      _OpozoriloBiometrika();
    }
  }

  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9), //add border radius
            child: Image.asset(
              "assets/1024.png",
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 25)),
          Text(
            "Prijava v sistem ŠCVApp",
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.27)),
          !_authorizedOrNot ? button() : CircularProgressIndicator(),
        ],
      ),
    )));
  }

  Widget button() {
    double widget = MediaQuery.of(context).size.width * 0.3;
    double height = widget * 0.36;
    double textSize = height * 0.37;
    return LayoutBuilder(builder: ((context, constraints) {
      return TextButton(
          child: Container(
            decoration: BoxDecoration(
              color: HexColor.fromHex("#16A7D4"),
              borderRadius: BorderRadius.circular(7),
            ),
            width: widget,
            height: height,
            child: Center(
                child: Text(
              "Avtorizacija",
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: textSize),
            )),
          ),
          onPressed: () {
            onStartUp();
          });
    }));
  }
}
