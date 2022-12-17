import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/komponeneteZaMalico.dart';
import 'package:scv_app/MalicePages/izberiJed.dart';
import 'package:scv_app/MalicePages/ostaleInformacije.dart';
import 'package:scv_app/MalicePages/prijavaMalice.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainMalicePage extends StatefulWidget {
  MainMalicePage({Key key, this.maliceUser, this.logedOutUser})
      : super(key: key);

  final MaliceUser maliceUser;
  final Function logedOutUser;

  _MainMalicePageState createState() => _MainMalicePageState();
}

class _MainMalicePageState extends State<MainMalicePage> {
  WebViewController _myController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  void logOutUser() async {
    await widget.maliceUser.logOutUser();
    widget.logedOutUser();
  }

  @override
  Widget build(BuildContext context) {
    // return new WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
    //     _myController = c;
    //   });

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(right: 20, left: 20),
          children: [
            Padding(padding: EdgeInsets.only(bottom: 15)),
            malica_Jed(
              imeJedi: "Pac kar je danes za jest",
              slika: AssetImage("assets/slikeMalica/mesni_meni.png"),
              naslov: "IZBRANA MALICA ZA DANES:",
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            malica_Info(
              opis: "Pin koda za prevzem malice:",
              informacija: widget.maliceUser != null
                  ? widget.maliceUser.pinNumber.toString()
                  : "",
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            malica_Info(
              opis: "Malica za jutri:",
              informacija: "Perutničke z medom, dušen riž, solata",
              height: 75,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            malica_Info(
              opis: "Stanje na računu",
              informacija:
                  "${widget.maliceUser != null ? widget.maliceUser.buget.toStringAsFixed(2) : ""}€",
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            malica_Info(
              opis: "Izberi si malico za naslednje dni",
              infoWidget: Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IzberiJedMalicePage())),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            malica_Info(
              opis: "Ostale informacije",
              infoWidget: Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OstaleInformacijeMalicePage(
                        maliceUser: widget.maliceUser,
                      ))),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            TextButton(onPressed: logOutUser, child: Text("Odjava"))
          ],
        ),
      ),
    );
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)