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

  @override
  Widget build(BuildContext context) {
    // return new WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
    //     _myController = c;
    //   });

    return GestureDetector(
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'E-pošta',
                      hintText: 'v formatu ime.priimek@scv.si')),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 20),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
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
                onPressed: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainMalicePage())),
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

    /* return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(right: 20,left: 20),
          children: [
            Padding(padding: EdgeInsets.only(bottom: 15)),
            malica_Jed(
              imeJedi: "Pac kar je danes za jest",
              slika: AssetImage("assets/slikeMalica/mesni_meni.png"),
              naslov: "IZBRANA MALICA ZA DANES:",
            ),
            Padding(padding: EdgeInsets.only(top:20)),
            malica_Info(
              opis: "Pin koda za prevzem malice:",
              informacija: "42069",
            ),
            Padding(padding: EdgeInsets.only(top:20)),
            malica_Info(
              opis: "Malica za jutri:",
              informacija: "Perutničke z medom, dušen riž, solata",
              height: 75,
            ),
            Padding(padding: EdgeInsets.only(top:20)),
            malica_Info(
              opis: "Stanje na računu",
              informacija: "420,69€",
            ),
            Padding(padding: EdgeInsets.only(top:20)),
            malica_Info(
              opis: "Izberi si malico za naslednje dni",
              infoWidget: Icon(
                Icons.arrow_forward_ios
              ),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => IzberiJedMalicePage())),
            ),
            Padding(padding: EdgeInsets.only(top:20)),
            malica_Info(
              opis: "Ostale informacije",
              infoWidget: Icon(
                Icons.arrow_forward_ios
              ),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => OstaleInformacijeMalicePage())),
            ),
          ],
        ),
      ),
    ); */
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)