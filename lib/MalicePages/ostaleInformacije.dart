import 'package:flutter/material.dart';
import 'package:scv_app/malice.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Components/komponeneteZaMalico.dart';

class OstaleInformacijeMalicePage extends StatefulWidget{
  OstaleInformacijeMalicePage({Key key,this.maliceUser}) : super(key: key);

  MaliceUser maliceUser;

  _OstaleInformacijeMalicePage createState() => _OstaleInformacijeMalicePage();
}

class _OstaleInformacijeMalicePage extends State<OstaleInformacijeMalicePage>{


  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 30)),
                    Icon(Icons.arrow_back_ios),
                    Text(
                      "Nazaj",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    malica_Info(
                      opis: "Ime in priimek:",
                      informacija: "${widget.maliceUser.firstName} ${widget.maliceUser.lastName}",
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    malica_Info(
                      opis: "IBAN:",
                      informacija: "SI56 0110 0603 0705 664 (BANKA SLOVENIJE LJUBLJANA)",
                      height: 80,
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    malica_Info(
                      opis: "Referenca:",
                      informacija: " SI00 555-${widget.maliceUser.referenceNumber==null?"":widget.maliceUser.referenceNumber}",
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    malica_Info(
                      opis: "Pomoč",
                      infoWidget: GestureDetector(
                      child: Text(
                        "Klikni tukaj",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                      ),
                      onTap: (){
                        launch(
                        "https://malice.scv.si/instructions",
                        forceSafariVC: false,
                        forceWebView: false,
                        );
                      },
                      )
                    )
                  ],
                ),
              )
            ],
          )
        ),
      );
  }
}