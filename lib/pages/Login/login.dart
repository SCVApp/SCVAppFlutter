import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:scv_app/api/EventTracking.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/global/global.dart' as global;

import '../../api/user.dart';
import '../../manager/extensionManager.dart';
import '../../store/AppState.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool isLoginIn = false;

  void loginUser() async {
    setState(() {
      isLoginIn = true;
    });
    await signInUser();
    if (!mounted) return;
    setState(() {
      isLoginIn = false;
    });
  }

  Future<void> signInUser() async {
    try {
      final result = await FlutterWebAuth2.authenticate(
          url: "${global.apiUrl}/auth/authUrl", callbackUrlScheme: "scvapp");

      final accessToken = Uri.parse(result).queryParameters['accessToken'];
      final refreshToken = Uri.parse(result).queryParameters['refreshToken'];
      final expiresOn = Uri.parse(result).queryParameters['expiresOn'];

      global.token.accessToken = accessToken;
      global.token.refreshToken = refreshToken;
      global.token.expiresOn = expiresOn;

      await global.token.saveToken();

      await global.token.refresh(force: true);

      await ExtensionManager.loadExtenstions(context);
      final User user = StoreProvider.of<AppState>(context).state.user;
      await user.fetchAll();
      await EventTracking.loginEvent(user.school.id, user.school.razred);
      StoreProvider.of<AppState>(context).dispatch(user);
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      final Urnik urnik = StoreProvider.of<AppState>(context).state.urnik;
      await urnik.refresh();
      StoreProvider.of<AppState>(context).dispatch(urnik);
    } catch (e) {
      ErrorInLogin();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loginUser());
  }

  void reTryLogin() {
    Navigator.pop(context);
    loginUser();
  }

  void goToOnBoardPage() {
    User user = StoreProvider.of<AppState>(context).state.user;
    user.logingIn = false;
    StoreProvider.of<AppState>(context).dispatch(user);
  }

  Future<void> ErrorInLogin() async {
    if (!mounted) return;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.error_login_witout_try),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.error_login),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(AppLocalizations.of(context)!.try_again_r,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: reTryLogin),
            TextButton(
                child: Text(AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: (() {
                  Navigator.pop(context);
                  goToOnBoardPage();
                })),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/1024.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            isLoginIn
                ? Text(AppLocalizations.of(context)!.wait_login,
                    style: TextStyle(fontSize: 17))
                : Text(AppLocalizations.of(context)!.error_login,
                    style: TextStyle(fontSize: 17)),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            TextButton(
                onPressed: goToOnBoardPage,
                child: Text(AppLocalizations.of(context)!.cancel)),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            isLoginIn == true ? loadingItem(Colors.blue) : SizedBox(),
          ]),
    )));
  }
}
