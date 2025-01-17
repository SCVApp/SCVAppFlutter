import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/global/global.dart' as global;

class LockerController {
  int id = 0;
  String name = "";
  int freeLockers = 0;

  LockerController(
      {required this.id, required this.name, required this.freeLockers});

  static Future<List<LockerController>> fetchControllers() async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/controllers";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': accessToken,
    });
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => LockerController.fromJson(e)).toList();
    }
    return [];
  }

  LockerController.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    freeLockers = json['freeLockers'];
  }

  Future<List<LockerWithActiveUserResult>?>
      fetchLockersWithActiveUsers() async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/${this.id}";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': accessToken,
    });
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => LockerWithActiveUserResult.fromJson(e)).toList();
    }
    return null;
  }
}
