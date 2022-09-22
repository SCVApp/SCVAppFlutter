import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:scv_app/Intro_And__Login/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';

class DoorUnlockPage extends StatefulWidget {
  DoorUnlockPage({Key key, this.data}) : super(key: key);

  final Data data;

  _DoorUnlockPage createState() => _DoorUnlockPage();
}

class _DoorUnlockPage extends State<DoorUnlockPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();
  }

  bool _value = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        backButton(context),
        Container(
            width: 300,
            height: 200,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                //Prva, vzorcna stran kartice
                Container( 
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                      color: HexColor.fromHex("#ca3a66"),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                  child: Image.asset(
                    'assets/pp.png',
                  ),
                ),
                //Druga, NFC kartica
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                      color: HexColor.fromHex("#0094d9"),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                  child: Image.asset(
                    'assets/nfc_glavna.png',
                  ),
                ),
                //Tretja, QR koda
                Container(
                  alignment: Alignment.center,
                  //padding: EdgeInsets.only(top: 40, left: 70, right: 40),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex("#0094d9"),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: 
                  SizedBox(
                    height: 150,
                    child: QrImage(
                      foregroundColor: Colors.black,
                      data: 'https://scv.si',
                      version: QrVersions.auto,
                      gapless: false,
                    ),
                  ),
                ),
              ],
            )),
        /* QrImage(
          data: "https://www.google.com",
          version: QrVersions.auto,
          size: 200.0,
        ), */
        Text("Test"),
      ],
    )));
  }
}
