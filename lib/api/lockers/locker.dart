import 'package:http/http.dart' as http;
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:scv_app/global/global.dart' as global;
import 'dart:convert';

class Locker {
  int id = 0;
  int controllerId = 0;
  String identifier = "";

  Locker(
      {required this.id, required this.controllerId, required this.identifier});

  static Future<Locker?> fetchMyLocker() async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/my";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': accessToken,
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Locker.fromJson(json);
    }
    return null;
  }

  static Future<OpenLockerResult> openLocker(int controllerId) async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/open";
    final response = await http.post(Uri.parse(url), headers: {
      'Authorization': accessToken,
    }, body: {
      'controllerId': controllerId.toString(),
    });
    final result = OpenLockerResult();
    if (response.statusCode == 200) {
      result.success = true;
    } else {
      final json = jsonDecode(response.body);
      if (json['message'] != null) {
        result.message = json['message'];
      }
    }
    return result;
  }

  static Future<EndLockerResult> endLocker() async {
    await global.token.refresh();
    final accessToken = global.token.getAccessToken();
    final url = global.apiUrl + "/lockers/end";
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

  Locker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    controllerId = json['controller']['id'];
    identifier = json['identifier'];
  }
}
