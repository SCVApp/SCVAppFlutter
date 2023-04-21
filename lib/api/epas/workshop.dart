import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/global/global.dart' as global;

class EPASWorkshop {
  int id;
  String name;
  String description;
  int timetable_id;

  int usersCount = 0;
  int maxUsers = 0;

  EPASWorkshop({
    this.id,
    this.name,
    this.description,
    this.timetable_id,
  });

  static fromJSON(json, int timetable_id) {
    return EPASWorkshop(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      timetable_id: timetable_id ?? json['timetable'],
    );
  }

  Future<void> getCountAndMaxUsers() async {
    try {
      final response = await http.get(
          Uri.parse("${EPASApi.EPASapiUrl}/workshop/copacity/$id"),
          headers: {'Authorization': global.token.accessToken});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        this.usersCount = json['count'];
        this.maxUsers = json['capacity'];
      }
    } catch (e) {}
  }
}
