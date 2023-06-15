import 'dart:convert';

import 'package:scv_app/api/malice/malica.dart';
import 'package:scv_app/api/malice/malicaMeni.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:http/http.dart' as http;

class MalicaDan {
  int id;
  int idNarocenegaMenija = 0;

  MalicaDan(this.id);

  List<MalicaMeni> meniji = [];

  Future<void> loadMenus() async {
    final String url = Malica.apiURL + "/menus?date=$id";
    final String accessToken = global.malicaAccessToken;
    try {
      final response = await http.get(Uri.parse(url),
          headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json["menus"] != null) {
          List<dynamic> menus = json["menus"];
          meniji = menus.map((e) => MalicaMeni.fromJson(e)).toList();
        }
        if (json["selected"] != null) {
          idNarocenegaMenija = int.parse(json["selected"].toString());
        }
      } else {
        throw Exception('Failed to load menus');
      }
    } catch (e) {
      print(e);
    }
  }

  MalicaMeni getSelectedMenu() {
    return meniji.firstWhere((element) => element.id == idNarocenegaMenija,
        orElse: () => null);
  }
}
