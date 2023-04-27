import 'dart:convert';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/api/epas/EPASAlert.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:scv_app/manager/extensionManager.dart';

import '../../store/AppState.dart';
import '../extension.dart';

class EPASApi extends Extension {
  List<EPASWorkshop> workshops = [];
  List<EPASWorkshop> joinedWorkshops = [];
  List<EPASTimetable> timetables = [];
  final EPASAlert alert = new EPASAlert();
  int userCode = 0;
  bool loading = false;
  static final String EPASapiUrl = 'http://localhost:3001/api';
  // static final String EPASapiUrl = 'https://scvepas.herokuapp.com/api';

  EPASApi() {
    this.name = 'EPAS';
  }

  @override
  Future<void> checkAuth() async {
    try {
      final response = await http.get(Uri.parse('${EPASapiUrl}/user'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        this.authorised = true;
      }
    } catch (e) {}
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
    } catch (e) {}
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

  Future<void> loadWorkshopsByName(String name) async {
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

  Future<void> loadLeaderWorkshops() async {
    try {
      final response = await http.get(
          Uri.parse('${EPASapiUrl}/user/myworkshops'),
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

  Future<void> loadJoinedWorkshops() async {
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
          timetable.selected_workshop_id = null;
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

  Future<void> loadUserCode() async {
    try {
      final response = await http.get(Uri.parse('${EPASapiUrl}/user/code'),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        this.userCode = int.parse(response.body);
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
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<bool> leaveWorkshop(int workshop_id) async {
    try {
      final response = await http.post(
          Uri.parse('${EPASapiUrl}/user/leaveworkshop'),
          headers: {'Authorization': global.token.accessToken},
          body: {'workshopId': workshop_id.toString()});
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {}
    return false;
  }

  static void showAlert(String info, bool isOk) {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(global.globalBuildContext)
            .state
            .extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions('EPAS');
    epasApi.alert.show(info, isOk);
    StoreProvider.of<AppState>(global.globalBuildContext)
        .dispatch(extensionManager);
    Future.delayed(Duration(seconds: 3), () {
      epasApi.alert.hide();
      StoreProvider.of<AppState>(global.globalBuildContext)
          .dispatch(extensionManager);
    });
  }
}
