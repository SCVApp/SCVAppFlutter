import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                    ),
                  onPressed: ()=>{widget.notifyParent(),Navigator.of(context).pop()}
                  ),
                  ),
                ],
              ),
              profilePictureWithStatus(widget.data),
              NastavitveGroup(
                settingsGroupTitle: "Statusi, ki so na voljo",
                items: getStatuses()
              )
            ],
          ),
        )
    );
  }

  chSt(String id) async{
    setState(() {
      widget.data.user.status.setStatus(id);
    });
    Timer(Duration(seconds: 1), () {
      widget.notifyParent();
      Navigator.of(context).pop();
    });
  }

  List<SettingsItem> getStatuses(){
    List<SettingsItem> result = [];
    for(StatusItem item in status){
      if(item.statusId == widget.data.user.status.id){
        item.trailing = Icon(Icons.check);
      }
      item.onTap = ()=>{
        chSt(item.statusId)
      };
      result.add(item);
    }
    return result;
  }
}
