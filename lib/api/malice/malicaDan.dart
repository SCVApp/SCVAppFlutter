import 'dart:convert';

import 'package:scv_app/api/malice/malica.dart';
import 'package:scv_app/api/malice/malicaMeni.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:http/http.dart' as http;

import 'malicaTipMeni.dart';

class MalicaDan {
  int id;
  int idNarocenegaMenija = 0;
  bool canOrder = false;
  bool canCancel = false;

  MalicaDan(this.id);

  List<MalicaMeni> meniji = [];
  List<MalicaTipMeni> tipiMenijev = [];

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
        if (json["types"] != null) {
          List<dynamic> menusTypes = json["types"];
          tipiMenijev =
              menusTypes.map((e) => MalicaTipMeni.fromJson(e)).toList();
        }
        if (json["selected"] != null) {
          idNarocenegaMenija = int.parse(json["selected"].toString());
        }
        if (json["can_order"] != null) {
          canOrder = json["can_order"];
        }
        if (json["can_cancel"] != null) {
          canCancel = json["can_cancel"];
        }
      } else {
        throw Exception('Failed to load menus');
      }
    } catch (e) {}
  }

  MalicaMeni? getSelectedMenu() {
    return meniji.firstWhere((element) => element.id == idNarocenegaMenija);
  }

  MalicaTipMeni? getTipMenija(MalicaMeni? meni) {
    return tipiMenijev
        .firstWhere((element) => element.id == (meni?.tip_id ?? 0));
  }

  static String getOpisMenija(MalicaMeni? meni) {
    return meni?.opis ?? "Brez malice";
  }

  static String getPictureUrl(MalicaTipMeni? tip) {
    return tip?.picture_url != null
        ? "assets/images/slikeMalica/" + tip!.picture_url
        : "assets/images/slikeMalica/brez_malice.png";
  }
}
