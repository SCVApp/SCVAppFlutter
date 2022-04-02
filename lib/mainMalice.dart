import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/komponeneteZaMalico.dart';
import 'package:scv_app/MalicePages/izberiJed.dart';
import 'package:scv_app/MalicePages/ostaleInformacije.dart';
import 'package:scv_app/mainMalice.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainMalicePage extends StatefulWidget {
  MainMalicePage({Key key, this.title}) : super(key: key);

  final String title;

  _MainMalicePageState createState() => _MainMalicePageState();
}

class _MainMalicePageState extends State<MainMalicePage> {
  WebViewController _myController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    // return new WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
    //     _myController = c;
    //   });

    return Scaffold(
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
    );
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)