import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/komponeneteZaMalico.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IzberiJedMalicePage extends StatefulWidget{
  IzberiJedMalicePage({Key key, this.title}) : super(key: key);

  final String title;

  _IzberiJedMalicePage createState() => _IzberiJedMalicePage();
}

class _IzberiJedMalicePage extends State<IzberiJedMalicePage>{

  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  
  List<malica_Jed_Izbira> maliceNaMenuju = [
    malica_Jed_Izbira(
      imeJedi: "Pac kar je danes za jest",
      slika: AssetImage("assets/slikeMalica/mesni_meni.png"),
      naslov: "Mesni meni",
      izbrana: true,
    ),
    malica_Jed_Izbira(
      imeJedi: "Pac kar je danes za jest",
      slika: AssetImage("assets/slikeMalica/vegi_meni.png"),
      naslov: "Vegi meni",
    ),
    malica_Jed_Izbira(
      imeJedi: "Klasična pizza",
      slika: AssetImage("assets/slikeMalica/pizza.png"),
      naslov: "Pizza",
    ),
    malica_Jed_Izbira(
      imeJedi: "Margarita pizza",
      slika: AssetImage("assets/slikeMalica/pizza_margerite.png"),
      naslov: "Pizza margerite",
    ),
    malica_Jed_Izbira(
      imeJedi: " Hamburger",
      slika: AssetImage("assets/slikeMalica/hamburger.png"),
      naslov: "Hamburger",
    ),
    malica_Jed_Izbira(
      imeJedi: "Solata",
      slika: AssetImage("assets/slikeMalica/solata.png"),
      naslov: "Solata",
    ),
    malica_Jed_Izbira(
      imeJedi: "Sendvič s tuno",
      slika: AssetImage("assets/slikeMalica/sendvic_s_tuno.png"),
      naslov: "Sendvič s tuno",
    ),
    malica_Jed_Izbira(
      imeJedi: "Kmečki sendvič",
      slika: AssetImage("assets/slikeMalica/kmecki_sendvic.png"),
      naslov: "Kmečki sendvič",
    ),
    malica_Jed_Izbira(
      imeJedi: "Sendvič s sirom",
      slika: AssetImage("assets/slikeMalica/sendvic_s_sirom.png"),
      naslov: "Sendvič s sirom",
    ),
    malica_Jed_Izbira(
      imeJedi: "Brez malice",
      slika: AssetImage("assets/slikeMalica/brez_malice.png"),
      naslov: "Brez malice",
    ),
  ];

  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 35,
                    ),
                  Text(
                    "Izbrani datum: 30.2.2022",
                    style: TextStyle(
                      fontWeight: FontWeight.w900
                    ),
                    ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 35,
                    ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              Expanded(child: ListView(
                padding: EdgeInsets.only(right: 40 ,left: 40),
                children: maliceZaTaDan(),
              )),
            ],
          )
        ),
      );
  }

  List<Widget> maliceZaTaDan(){
    List<Widget> ret = [];
    for(malica_Jed_Izbira item in maliceNaMenuju){
      item.onTap = (){
        print(item.naslov);
      };
      ret.add(item);
      ret.add(Padding(padding: EdgeInsets.only(top:10)));
    }
    return ret;
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)