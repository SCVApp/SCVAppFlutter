import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Components/nastavitveGroup.dart';
import 'package:scv_app/Components/profilePictureWithStatus.dart';
import 'package:scv_app/Components/statusItems.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';


class ChangeStatusPage extends StatefulWidget {
  ChangeStatusPage({Key key, this.data}) : super(key: key);

  final Data data;

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
                  onPressed: ()=>Navigator.of(context).pop()
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

  List<SettingsItem> getStatuses(){
    List<SettingsItem> result = [];
    for(StatusItem item in status){
      if(item.statusId == widget.data.user.status.id){
        item.trailing = Icon(Icons.check);
      }
      result.add(item);
    }
    return result;
  }
}
