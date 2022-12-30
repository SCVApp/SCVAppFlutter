import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:scv_app/extension/hexColor.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

class School {
  String id;
  String urnikUrl;
  String color;
  String schoolUrl;
  String name;
  String razred;
  Color schoolColor;

  School() {
    this.color = "#0094d9";
    this.schoolColor = HexColor.fromHex("#0094d9");
    this.id = "";
    this.urnikUrl = "";
    this.schoolUrl = "";
    this.name = "";
    this.razred = "";
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(global.apiUrl + "/user/school"),
        headers: {"Authorization": global.token.accessToken});
    print(response.statusCode);
    if (response.statusCode == 200) {
      this.fromJSON(jsonDecode(response.body));
      this.saveToCache();
    } else {
      throw Exception('Failed to load school');
    }
  }

  void fromJSON(Map<String, dynamic> json) {
    this.id = json['id'].toString();
    this.urnikUrl = json['urnikUrl'].toString();
    this.color = json['color'].toString();
    this.schoolUrl = json['schoolUrl'].toString();
    this.name = json['name'].toString();
    this.razred = json['razred'].toString();
    if (this.color == "#FFFFFF") {
      this.color = "#8253D7";
    }
    this.schoolColor = HexColor.fromHex(this.color);
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': this.id,
      'urnikUrl': this.urnikUrl,
      'color': this.color,
      'schoolUrl': this.schoolUrl,
      'name': this.name,
      'razred': this.razred,
    };
  }

  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('school', jsonEncode(this.toJSON()));
  }

  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final school = prefs.getString('school');
    if (school != null) {
      this.fromJSON(jsonDecode(school));
    }
  }
}
