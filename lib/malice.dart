import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/komponeneteZaMalico.dart';
import 'package:scv_app/MalicePages/izberiJed.dart';
import 'package:scv_app/MalicePages/ostaleInformacije.dart';
import 'package:scv_app/MalicePages/mainMalice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

MaliceUser maliceUser = new MaliceUser("");

class MaliceUser {
  String accessToken;
  String email;
  String firstName;
  String lastName;
  num buget;
  String referenceNumber;
  int pinNumber;

  MaliceUser(String body){
    if(body != ""){
      this.loadJson(body);
    }
  }

  loadJson(String body){
    final decoded = jsonDecode(body);
    this.accessToken = decoded['access_token'];
    this.email = decoded['student']['email'];
    this.firstName = decoded['student']['first_name'];
    this.lastName = decoded['student']['last_name'];
    this.buget = decoded['student']['budget'];
    this.referenceNumber = decoded['student']['reference'];
    this.pinNumber = decoded['student']['pin_number'];
  }

  Map<String, dynamic> toJson() => {
        'access_token': this.accessToken,
        'student': {
          'email':this.email,
          'first_name':this.firstName,
          'last_name':this.lastName,
          'budget':this.buget,
          'reference':this.referenceNumber,
          'pin_number':this.pinNumber,
        },
      };
  void saveUser() async{
    String jsonString = jsonEncode(this);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userMalica", jsonString);
  }
  Future<bool> loadUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      String jsonString = prefs.getString("userMalica");
      if(jsonString != ""){
        this.loadJson(jsonString);
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }
  void logOutUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userMalica");
  }
}

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

  String errorMessage = "";
  void showError(String errMsg){
    setState(() {
      errorMessage=errMsg;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadIfLogedIn();
  }

  logedOutUser(){
    setState(() {
      isLogedIn=false;
      isLoggingIn=false;
    });
  }

  loadIfLogedIn() async{
    if(await maliceUser.loadUser() == true){
      setState(() {
        isLogedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return new WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
    //     _myController = c;
    //   });

    logInUser() async {
      String username = field_username_controller.text.toString();
      String password = field_password_controller.text.toString();

      if(username != "" && password != ""){
        setState(() {
          isLoggingIn = true;
        });
        var formData = new Map<String, dynamic>();
        formData['email'] = username;
        formData['password'] = password;
        showError("");
        final response = await http.post(Uri.parse("https://malice.scv.si/api/v2/auth"),body: formData);
        setState(() {
          isLoggingIn = false;
        });
        if(response.statusCode == 200){
          maliceUser = new MaliceUser(response.body);
          setState(() {
            isLogedIn = true;
          });
          await maliceUser.saveUser();
          field_password_controller.text = "";
          field_username_controller.text = "";
        }else if(response.statusCode == 401){
          var err = jsonDecode(response.body)["errors"];
          if(err == "Invalid email/password!"){
            showError("Napačna e-pošta ali geslo");
          }
        }else if(response.statusCode == 500){
          showError("Napačna e-pošta ali geslo");
        }
      }
    }
    return isLoggingIn ? Center(child: CircularProgressIndicator(),) : isLogedIn ? MainMalicePage(maliceUser: maliceUser,logedOutUser: logedOutUser,) : 
    GestureDetector(
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
                    // color: Theme.of(context).primaryColor==Colors.white ? Colors.white : Colors.transparent,
                    child: Image.asset('assets/school_logo.png')),
              ),
            ),
            AutofillGroup(child: Column(children: [
              Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  controller: field_username_controller,
                  autocorrect: false,
                  autofillHints: [AutofillHints.email],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      labelText: 'E-pošta',
                      hintText: 'E-poštni naslov v obliki ime.priimek@scv.si')),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 20),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: field_password_controller,
                obscureText: true,
                autocorrect: false,
                autofillHints: [AutofillHints.password],
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(),
                    labelText: 'Geslo',
                    hintText: 'Geslo za dostop do sistema malic'),
              ),
            ),
            ],)),
            errorMessage != "" ? Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 20),
              // padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(errorMessage,style: TextStyle(color: Colors.red,fontSize: 16, fontWeight: FontWeight.bold),),
            ):SizedBox(),
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
                  'Pozabljeno geslo',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                onPressed: ()=>launchUrl(Uri.parse("https://malice.scv.si/students/password/new"), mode: LaunchMode.externalApplication),
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