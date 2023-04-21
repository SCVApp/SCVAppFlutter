import 'dart:convert';

import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;

import '../extension.dart';

class EPASApi extends Extension {
  List<EPASWorkshop> workshops = [];
  List<EPASWorkshop> joinedWorkshops = [];
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

  void loadWorkshopsByName(String name) async {
    if (name == null) return;
    try {
      final response = await http.get(
          Uri.parse('${EPASapiUrl}/workshop/name/$name'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        this.workshops = json
            .map<EPASWorkshop>((json) => EPASWorkshop.fromJSON(json, null))
            .toList();
        this.workshops.sort((a, b) => a.timetable_id.compareTo(b.timetable_id));
      }
    } catch (e) {}
    loading = false;
  }

  void loadJoinedWorkshops() async {
    try {
      final response = await http.get(
          Uri.parse('${EPASapiUrl}/user/joinedworkshops'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        this.joinedWorkshops = json
            .map<EPASWorkshop>((json) => EPASWorkshop.fromJSON(json, null))
            .toList();
        for (EPASTimetable timetable in this.timetables) {
          for (EPASWorkshop workshop in this.joinedWorkshops) {
            if (workshop.timetable_id == timetable.id) {
              timetable.selected_workshop_id = workshop.id;
            }
          }
        }
      }
    } catch (e) {}
    loading = false;
  }

  static Future<bool> joinWorkshop(int workshop_id) async {
    try {
      final response = await http.post(
          Uri.parse('${EPASapiUrl}/user/joinworkshop'),
          headers: {'Authorization': global.token.accessToken},
          body: {'workshopId': workshop_id.toString()});
      if (response.statusCode == 200) {
        print("Joined workshop");
        return true;
      } else {}
    } catch (e) {
      print(e);
    }
    return false;
  }
}
