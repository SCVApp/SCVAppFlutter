import 'dart:convert';

import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;

import '../extension.dart';

class EPASApi extends Extension {
  List<EPASWorkshop> workshops = [];
  List<EPASTimetable> timetables = [];
  bool loading = false;
  static final String EPASapiUrl = 'http://localhost:3001/api';

  EPASApi() {
    this.name = 'EPAS';
  }

  @override
  void checkAuth() async {
    try {
      final response = await http.get(Uri.parse('${EPASapiUrl}/user'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        this.authorised = true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadTimetables() async {
    try {
      final response = await http.get(Uri.parse('${EPASapiUrl}/timetable/all'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        this.timetables = json
            .map<EPASTimetable>((json) => EPASTimetable.fromJSON(json))
            .toList();
        this.timetables.sort((a, b) => a.start.compareTo(b.start));
      }
    } catch (e) {
      print(e);
    }
    loading = false;
  }

  void loadWorkshops(int timetable_id) async {
    if (timetable_id == null) return;
    try {
      final response = await http.get(
          Uri.parse('${EPASapiUrl}/workshop/timetable/$timetable_id'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        this.workshops = json
            .map<EPASWorkshop>(
                (json) => EPASWorkshop.fromJSON(json, timetable_id))
            .toList();
        this.workshops.sort((a, b) => a.name.compareTo(b.name));
      }
    } catch (e) {
      print(e);
    }
    loading = false;
  }
}
