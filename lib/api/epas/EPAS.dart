import 'dart:convert';

import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;

class EPASApi {
  List<EPASWorkshop> workshops = [];
  List<EPASTimetable> timetables = [];
  bool loading = false;
  static final String EPASapiUrl = 'http://localhost:3000/api';

  void loadTimetables() async {
    try {
      final response = await http.get(Uri.parse('${EPASapiUrl}/timetable/all'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        this.timetables = jsonDecode(response.body)
            .map<EPASTimetable>((json) => EPASTimetable.fromJSON(json))
            .toList();
      }
    } catch (e) {
      print(e);
    }
  }

  void loadWorkshops(int timetable_id) async {
    try {
      final response = await http.get(
          Uri.parse('${EPASapiUrl}/workshop/timetable/$timetable_id'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        this.workshops = jsonDecode(response.body)
            .map<EPASWorkshop>(
                (json) => EPASWorkshop.fromJSON(json, timetable_id))
            .toList();
      }
    } catch (e) {
      print(e);
    }
  }
}
