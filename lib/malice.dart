import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/komponeneteZaMalico.dart';
import 'package:scv_app/MalicePages/izberiJed.dart';
import 'package:scv_app/MalicePages/ostaleInformacije.dart';
import 'package:scv_app/MalicePages/mainMalice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MalicePage extends StatefulWidget {
  MalicePage({Key key, this.title}) : super(key: key);

  final String title;

  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage> {
  WebViewController _myController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool isLoggingIn = false;
  bool isLogedIn = false;

  final field_username_controller = TextEditingController();
  final field_password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return new WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
    //     _myController = c;
    //   });

    logInUser() async {
      String username = field_username_controller.text.toString();
      String password = field_password_controller.text.toString();
      print("Username: $username");
      print("Password: $password");
      setState(() {
        isLoggingIn = true;
      });
      await Future.delayed(Duration(seconds: 1),(){
        setState(() {
          isLogedIn = true;
          isLoggingIn = false;
        });
      });
    }

    return isLoggingIn ? Center(child: CircularProgressIndicator(),) : isLogedIn ? MainMalicePage() : GestureDetector(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Prijava v sistem malic",
              style: TextStyle(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/school_logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  controller: field_username_controller,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      labelText: 'E-pošta',
                      hintText: 'v formatu ime.priimek@scv.si')),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 20),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: field_password_controller,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(),
                    labelText: 'Geslo',
                    hintText: 'Geslo, uporabljeno za malice'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: logInUser,
                child: Text(
                  'Prijava',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              height: 100,
              width: 250,
              child: TextButton(
                child: Text(
                  'Pozabljeno geslo?',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                onPressed: ()=>launch("https://malice.scv.si/students/password/new"),
              ),
            ),
          ],
        ),
      ),
      onTap: ()=> FocusManager.instance.primaryFocus.unfocus()
    );
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)