import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/components/EPAS/halfScreenCard.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;

import '../../store/AppState.dart';

class EPASAdminChechView extends StatefulWidget {
  EPASAdminChechView(this.code, this.workshopId, {Key key}) : super(key: key);
  final int code;
  final int workshopId;
  @override
  _EPASAdminChechViewState createState() => _EPASAdminChechViewState();
}

class _EPASAdminChechViewState extends State<EPASAdminChechView> {
  Color backgroundColor = EPASStyle.alreadyJoinedColor;
  EPASWorkshop otherWorkshop;
  EPASTimetable otherTimetable;
  bool isJoinedAtWorkshop = false;
  String userAzureId;

  void chechUserIfJoinInWorkshop() async {
    try {
      final response = await http.post(
          Uri.parse('${EPASApi.EPASapiUrl}/user/chech_join_workshop'),
          headers: <String, String>{
            'Authorization': '${global.token.accessToken}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "userCode": widget.code.toString(),
            "workshopId": widget.workshopId.toString()
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final bool isJoinedAtWorkshop = data["isJoinedAtWorkshop"] ?? false;
        if (isJoinedAtWorkshop) {
          setState(() {
            backgroundColor = EPASStyle.freePlaceColor;
            this.isJoinedAtWorkshop = true;
          });
          setState(() {
            this.userAzureId = data["user"]["azureId"];
          });
        } else {
          setState(() {
            backgroundColor = EPASStyle.fullPlaceColor;
            this.isJoinedAtWorkshop = false;
          });
          setState(() {
            this.otherWorkshop = EPASWorkshop.fromJSON(data["workshop"], null);
          });
          final ExtensionManager extensionManager =
              StoreProvider.of<AppState>(context).state.extensionManager;
          final EPASApi epasApi = extensionManager.getExtensions("EPAS");
          final EPASTimetable timetable = epasApi.timetables.firstWhere(
              (element) => element.id == otherWorkshop.timetable_id,
              orElse: () => null);
          setState(() {
            this.otherTimetable = timetable;
          });
        }
      }
    } catch (e) {}
  }

  void approveAttendenc() async {
    try {
      final response = await http.post(
          Uri.parse('${EPASApi.EPASapiUrl}/user/approve_attendenc'),
          headers: <String, String>{
            'Authorization': '${global.token.accessToken}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "azureId": userAzureId,
            "workshopId": widget.workshopId.toString()
          }));
      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    chechUserIfJoinInWorkshop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          bottom: false,
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
                  rightPadding: 25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 50)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Ime in priimek",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Urban Krepel")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Prijavljen na to delavnico",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(this.isJoinedAtWorkshop ? "DA" : "NE",
                                  style: TextStyle(
                                      color: this.backgroundColor,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Prijavljen ob uri",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(this.isJoinedAtWorkshop ? "11.00" : "/")
                            ],
                          )
                        ].withSpaceBetween(spacing: 20),
                      ),
                      Column(
                        children: [
                          if (this.otherWorkshop != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                Expanded(
                                    child: Text(
                                  "Uporabnik je prijavljen na delavnico ${this.otherWorkshop.name.toUpperCase()}, ob ${this.otherTimetable?.getStartHour() ?? ""}",
                                  textAlign: TextAlign.center,
                                ))
                              ],
                            ),
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: this.isJoinedAtWorkshop
                                      ? EPASStyle.backgroundColor
                                      : EPASStyle.alreadyJoinedColor),
                              onPressed: this.isJoinedAtWorkshop
                                  ? approveAttendenc
                                  : () {},
                              child: Padding(
                                child: Text(
                                  this.isJoinedAtWorkshop
                                      ? "POTRDI UDELEŽBO"
                                      : "POTRJEVANJE NI MOŽNO",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                              )),
                          Padding(padding: EdgeInsets.only(bottom: 20))
                        ],
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
