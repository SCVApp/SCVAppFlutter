import 'dart:convert';

import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Urnik {
  List<ObdobjaUr> obdobjaUr = [];
  int indexTrenutnegaObdobja = -1;
  int indexNaslednjegaObdobja = -1;
  DateTime nazadnjePosodobljeno = DateTime.fromMillisecondsSinceEpoch(0);

  static final String unrikKey = "SCV-App-Urnik";

  Future<void> fetchFromWeb() async {
    try {
      final response = await http.get(
          Uri.parse('${global.apiUrl}/user/schedule'),
          headers: {"Authorization": global.token.accessToken});
      if (response.statusCode == 200) {
        this.fromJSON(jsonDecode(response.body));
        this.nazadnjePosodobljeno = DateTime.now();
        await this.save();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> refresh() async {
    await this.load();
    if (this
        .nazadnjePosodobljeno
        .isBefore(DateTime.now().subtract(Duration(hours: 1)))) {
      await this.fetchFromWeb();
    }
  }

  void fromJSON(Map<String, dynamic> json) {
    this.nazadnjePosodobljeno = DateTime.parse(json["nazadnjePosodobljeno"]);
    for (var obdobje in json["urnik"]) {
      ObdobjaUr obdobjaUr = new ObdobjaUr();
      obdobjaUr.fromJSON(obdobje);
      this.obdobjaUr.add(obdobjaUr);
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      "urnik": this.obdobjaUr,
      "nazadnjePosodobljeno": this.nazadnjePosodobljeno.toString(),
    };
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(this);
    print(json);
    await prefs.setString(unrikKey, json);
  }

  Future<void> load() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String urnik = prefs.getString(unrikKey);
      if (urnik != null) {
        this.fromJSON(jsonDecode(urnik));
      }
    } catch (e) {
      print(e);
    }
  }
}
