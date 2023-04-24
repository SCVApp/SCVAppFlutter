import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/components/EPAS/halfScreenCard.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:http/http.dart' as http;

class EPASAdminChechView extends StatefulWidget {
  EPASAdminChechView(this.code, {Key key}) : super(key: key);
  final int code;
  @override
  _EPASAdminChechViewState createState() => _EPASAdminChechViewState();
}

class _EPASAdminChechViewState extends State<EPASAdminChechView> {
  Color backgroundColor = EPASStyle.alreadyJoinedColor;

  void chechUserIfJoinInWorkshop() async {
    try {
      final response = await http.post(
          Uri.parse('${EPASApi.EPASapiUrl}/user/chech_join_workshop'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: {
            "userCode": widget.code.toString(),
            "workshopId": "1"
          });
      if (response == 200) {
        final Map<String, String> data = jsonDecode(response.body);
        final bool isJoinedAtWorkshop = data["isJoinedAtWorkshop"] as bool;
        if (isJoinedAtWorkshop) {
          setState(() {
            backgroundColor = EPASStyle.freePlaceColor;
          });
        } else {
          setState(() {
            backgroundColor = EPASStyle.fullPlaceColor;
          });
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chechUserIfJoinInWorkshop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          HalfScreenCard(context,
              child: Column(
                children: [Text("Ime in priimek")],
              ))
        ],
      )),
    );
  }
}
