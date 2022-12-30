import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:scv_app/global/global.dart' as global;

import 'package:scv_app/pages/Login/intro.dart';

import '../../api/user.dart';
import '../../store/AppState.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoginIn = false;

  void loginUser() async {
    setState(() {
      isLoginIn = true;
    });
    await signInUser();
    setState(() {
      isLoginIn = false;
    });
  }

  Future<void> signInUser() async {
    try {
      final result = await FlutterWebAuth.authenticate(
          url: "${global.apiUrl}/auth/authUrl", callbackUrlScheme: "scvapp");

      final accessToken = Uri.parse(result).queryParameters['accessToken'];
      final refreshToken = Uri.parse(result).queryParameters['refreshToken'];
      final expiresOn = Uri.parse(result).queryParameters['expiresOn'];

      global.token.accessToken = accessToken;
      global.token.refreshToken = refreshToken;
      global.token.expiresOn = expiresOn;

      await global.token.saveToken();

      final User user = StoreProvider.of<AppState>(context).state.user;
      await user.fetchData();
      StoreProvider.of<AppState>(context).dispatch(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    loginUser();
  }

  void reTryLogin() {
    Navigator.pop(context);
    loginUser();
  }

  void goToOnBoardPage() {
    Navigator.pop(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginIntro()));
  }

  Future<void> ErrorInLogin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Napaka pri prijavi!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Napaka pri prijavi. Prosim, poskusi znova'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Poskusi znova',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: reTryLogin),
            TextButton(
                child: const Text('Prekliči',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: goToOnBoardPage),
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
            Text("Prosim počakaj, prijava poteka...",
                style: TextStyle(fontSize: 17)),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            isLoginIn ? CircularProgressIndicator() : SizedBox(),
          ]),
    )));
  }
}
