import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/components/EPAS/timetableSelection/dialog.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:scv_app/pages/EPAS/style.dart';

class EPASWorkshop {
  int id = 0;
  String name = "";
  String description = "";
  int timetable_id = 0;
  bool attended = false;

  int usersCount = 0;
  int maxUsers = 0;

  EPASWorkshop({
    required this.id,
    required this.name,
    required this.description,
    required this.timetable_id,
    required this.attended,
  });

  static fromJSON(json, int? timetable_id, {bool timetable_object = false}) {
    final int? id =
        timetable_object ? json['timetable']['id'] : json['timetable'];
    return EPASWorkshop(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      timetable_id: timetable_id ?? id ?? 0,
      attended: json['attended'] ?? false,
    );
  }

  Future<void> getCountAndMaxUsers() async {
    try {
      final response = await http.get(
          Uri.parse("${EPASApi.EPASapiUrl}/workshop/copacity/$id"),
          headers: {'Authorization': global.token.getAccessToken()});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        this.usersCount = json['count'];
        this.maxUsers = json['capacity'];
      }
    } catch (e) {}
  }

  static void errorJoinWithSameName(
      BuildContext context, Function joinWorkshop, int workshopWithSameNameId) {
    AlertDialog alertDialog = EPASTimetableSelectionDialog("Enaka delavnica!",
        "Nemorete se prijaviti na delavnico z istim imenom. Ali želi spremeniti termin delavnice?",
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            child:
                Text("Ne", style: TextStyle(color: EPASStyle.backgroundColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            child:
                Text("Da", style: TextStyle(color: EPASStyle.backgroundColor)),
            onPressed: () =>
                changeWorkshop(context, joinWorkshop, workshopWithSameNameId),
          ),
        ]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  static void changeWorkshop(BuildContext context, Function joinWorkshop,
      int workshopWithSameNameId) async {
    await EPASApi.leaveWorkshop(workshopWithSameNameId);
    Navigator.of(context).pop();
    joinWorkshop(successMessage: "Sprememba termina delavnice uspešna!");
  }
}
