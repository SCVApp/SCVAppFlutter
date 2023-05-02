import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/components/EPAS/halfScreenCard.dart';
import 'package:scv_app/components/loadingItem.dart';
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
  bool loading = false;
  String username = "/";

  void chechUserIfJoinInWorkshop() async {
    setState(() {
      loading = true;
    });
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
          getUsername(userAzureId);
        } else {
          setState(() {
            backgroundColor = EPASStyle.fullPlaceColor;
            this.isJoinedAtWorkshop = false;
          });
          setState(() {
            this.otherWorkshop = EPASWorkshop.fromJSON(data["workshop"], null,
                timetable_object: true);
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
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        showErrorDialog(data["message"]);
      }
    } catch (e) {}
    setState(() {
      loading = false;
    });
  }

  void getUsername(String azureId) async {
    if (azureId == null) return;
    try {
      final response = await http.get(
          Uri.parse("${global.apiUrl}/search/specificUser/$azureId"),
          headers: {
            'Authorization': '${global.token.accessToken}',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String username = data["displayName"];
        setState(() {
          this.username = username;
        });
      }
    } catch (e) {}
  }

  void showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Napaka"),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("OK",
                      style: TextStyle(color: EPASStyle.backgroundColor))),
            ],
          );
        });
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
                  child: !this.loading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 50)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ime in priimek",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(username)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Prijavljen na to delavnico",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(this.isJoinedAtWorkshop ? "DA" : "NE",
                                        style: TextStyle(
                                            color: this.backgroundColor,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                StoreConnector<AppState, ExtensionManager>(
                                    converter: (store) =>
                                        store.state.extensionManager,
                                    builder: (context, extensionManager) {
                                      final EPASApi epasApi = extensionManager
                                          .getExtensions("EPAS");
                                      final EPASWorkshop workshop =
                                          epasApi.workshops.firstWhere(
                                              (element) =>
                                                  element.id ==
                                                  widget.workshopId,
                                              orElse: () => null);
                                      final EPASTimetable timetable =
                                          epasApi.timetables.firstWhere(
                                              (element) =>
                                                  element.id ==
                                                  workshop?.timetable_id,
                                              orElse: () => null);
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Prijavljen ob uri",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(this.isJoinedAtWorkshop
                                              ? timetable?.getStartHour() ?? "/"
                                              : "/")
                                        ],
                                      );
                                    })
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
                                        size: 50,
                                      ),
                                      Expanded(
                                          child: Text(
                                        "Uporabnik je prijavljen na delavnico ${this.otherWorkshop.name.toUpperCase()}, ob ${this.otherTimetable?.getStartHour() ?? ""}",
                                        textAlign: TextAlign.left,
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
                        )
                      : loadingItem(EPASStyle.backgroundColor))
            ],
          )),
    );
  }
}
