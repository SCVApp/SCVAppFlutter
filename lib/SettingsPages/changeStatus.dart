import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Components/nastavitveGroup.dart';
import 'package:scv_app/Components/profilePictureWithStatus.dart';
import 'package:scv_app/Components/statusItems.dart';
import 'package:scv_app/nastavitve.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';


class ChangeStatusPage extends StatefulWidget {
  final Function() notifyParent;
  ChangeStatusPage({Key key, this.data,@required this.notifyParent}) : super(key: key);
  Data data;

  _ChangeStatusPage createState() => _ChangeStatusPage();
}

class _ChangeStatusPage extends State<ChangeStatusPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  String token = "";

  bool isLoadingNewInfo = false;

  List<Widget> status = [
    StatusItem(
      title: "Dosegljiv",
      imageProvider: AssetImage("assets/statusIcons/available.png"),
      statusId: "available",
    ),
    StatusItem(
      title: "Odsoten",
      imageProvider: AssetImage("assets/statusIcons/away.png"),
      statusId: "away",
    ),
    StatusItem(
      title: "Takoj bom nazaj",
      imageProvider: AssetImage("assets/statusIcons/brb.png"),
      statusId: "brb",
    ),
    StatusItem(
      title: "Zaseden/-a",
      imageProvider: AssetImage("assets/statusIcons/busy.png"),
      statusId: "busy",
    ),
    StatusItem(
      title: "Ne motite",
      imageProvider: AssetImage("assets/statusIcons/dnd.png"),
      statusId: "dnd",
    ),
    StatusItem(
      title: "Nedosegljiv",
      imageProvider: AssetImage("assets/statusIcons/offline.png"),
      statusId: "offline",
    ),
  ];

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
            // crossAxisAlignment: CrossAxisAlignment.center,
              backButton(context),
              isLoadingNewInfo ? Text("") : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profilePictureWithStatus(widget.data),
                ],
              ),
              isLoadingNewInfo ? Text("") : Row(children: [Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Statusi, ki so še na voljo:",
                    style: TextStyle(fontSize: 22 * MediaQuery.of(context).textScaleFactor, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),]),
              isLoadingNewInfo ? Center(child: CircularProgressIndicator()) :
              Expanded(child: ListView(
                children: [
                  NastavitveGroup(
                    items: getStatuses()
                  ),
                ],
              )),
          ]
        )
    ));
  }

  chSt(String id) async{
    setState((){
      isLoadingNewInfo = true;
    });
    UserStatusData nev = await widget.data.user.status.setStatus(id);
    widget.notifyParent();
    setState(() {
      widget.data.user.status.setS(nev);
      isLoadingNewInfo = false;
    });
  }

  List<SettingsItem> getStatuses(){
    List<SettingsItem> result = [];
    for(StatusItem item in status){
      if(item.statusId == widget.data.user.status.id){
        item.trailing = Icon(Icons.check);
      }else{
        item.trailing = null;
      }
      item.onTap = ()=>{
        chSt(item.statusId)
      };
      result.add(item);
    }
    return result;
  }
}
