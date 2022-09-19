import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:scv_app/Intro_And__Login/uvod.dart';
import '../Data/data.dart';

import '../main.dart';

class LoginInPage extends StatefulWidget {
  LoginInPage({Key key, this.data}) : super(key: key);

  final Data data;

  _LoginInPage createState() => _LoginInPage();
}

class _LoginInPage extends State<LoginInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoginIn = false;

  void loginUser() async {
    setState(() {
      isLoginIn = true;
    });
    UserData user = await signInUser();
    setState(() {
      isLoginIn = false;
    });
    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      ErrorInLogin();
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnBoardingPage()));
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
                Text('Prijava v aplikacijo ni uspela. Poskusite znova!'),
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
              "assets/1024.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Text("Prosim počakajte, da vas prijavimo...",
                style: TextStyle(fontSize: 17)),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            isLoginIn ? CircularProgressIndicator() : SizedBox(),
          ]),
    )));
  }
}
