import 'package:http/http.dart' as http;
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:scv_app/global/global.dart' as global;
import 'dart:convert';

class Locker {
  int id = 0;
  int controllerId = 0;
  String identifier = "";
  bool used = false;

  Locker(
      {required this.id,
      required this.controllerId,
      required this.identifier,
      this.used = false});

  static Future<List<Locker>> fetchMyLockers() async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/my";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': accessToken,
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final lockers = <Locker>[];
      for (var locker in json) {
        lockers.add(Locker.fromJson(locker));
      }
      return lockers;
    }
    return [];
  }

  Future<OpenLockerResult> openLocker() async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/open";
    final response = await http.post(Uri.parse(url), headers: {
      'Authorization': accessToken,
    }, body: {
      'lockerId': this.id.toString(),
    });
    final result = OpenLockerResult();
    if (response.statusCode == 200) {
      result.success = true;
      result.message = "Omarica je uspešno odprta.";
    } else {
      final json = jsonDecode(response.body);
      if (json['message'] != null) {
        result.message = json['message'];
      }
    }
    return result;
  }

  Future<EndLockerResult> endLocker() async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/end";
    final response = await http.post(Uri.parse(url), headers: {
      'Authorization': accessToken,
    }, body: {
      'lockerId': this.id.toString(),
    });
    final result = EndLockerResult();
    if (response.statusCode == 200) {
      result.success = true;
      result.message = "Omarica je uspešno odprta in vrnjena.";
    } else {
      final json = jsonDecode(response.body);
      if (json['message'] != null) {
        result.message = json['message'];
      }
    }
    return result;
  }

  static Future<OpenLockerResult> openLockerAdmin(int lockerId) async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/open/$lockerId";
    final response = await http.post(Uri.parse(url), headers: {
      'Authorization': accessToken,
    });
    final result = OpenLockerResult();
    if (response.statusCode == 200) {
      result.success = true;
      result.message = "Omarica je uspešno odprta.";
    } else {
      final json = jsonDecode(response.body);
      if (json['message'] != null) {
        result.message = json['message'];
      }
    }
    return result;
  }

  static Future<EndLockerResult> endLockerAdmin(int lockerId) async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/end/$lockerId";
    final response = await http.post(Uri.parse(url), headers: {
      'Authorization': accessToken,
    });
    final result = EndLockerResult();
    if (response.statusCode == 200) {
      result.success = true;
      result.message = "Omarica je uspešno odprta in vrnjena.";
    } else {
      final json = jsonDecode(response.body);
      if (json['message'] != null) {
        result.message = json['message'];
      }
    }
    return result;
  }

  Locker.fromJson(Map<String, dynamic> json, {int controllerId = 0}) {
    id = json['id'];
    controllerId = controllerId;
    if (json['controller'] != null) {
      controllerId = json['controller']['id'];
    }
    identifier = json['identifier'];
    used = json['used'] ?? false;
  }
}
