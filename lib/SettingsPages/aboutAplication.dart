import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Components/settingsUserCard.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutAppPage extends StatefulWidget {
  AboutAppPage({Key key, this.data}) : super(key: key);

  final Data data;

  _AboutAppPage createState() => _AboutAppPage();
}


Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
class _AboutAppPage extends State<AboutAppPage> {
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
              Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: Center(
              child: Container(
                  width: 200,
                  height: 150,
                  child: Image.asset('assets/school_logo.png')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text("Aplikacija ŠCVApp je namenjena dijakom in učiteljem šolskega centra Velenje. Ustvarila sva jo Blaž Osredkar in Urban Krepel v sklopu raziskovalne naloge. \n  \nAplikacija vsebuje orodja, ki so potrebna za šolanje: \n • domača stran spletne šole, \n • spletni portal malice,\n • urnik za razred, ki ga obiskujemo,..\n\nK aplikaciji bova sproti dodajala še dodatna orodja in novosti. Če imaš vprašanje, nama ga napiši na info.app@scv.si.", textAlign: TextAlign.justify,),
          ),  
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text("Uporabne povezave", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left),
          ),
          ],
          ),
          
        )
    ); 
  }
  }