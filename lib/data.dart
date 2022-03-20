import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scv_app/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Sola{
  String id;//ERS,SSG
  String homeUrl;
  String noviceUrl;
  String urnikUrl;
  Color color;

  Sola(String _id, String _homeUrl, String _noviceUrl, String _urnikUrl, Color _color){
    this.id = _id;
    this.homeUrl = _homeUrl;
    this.noviceUrl = _noviceUrl;
    this.urnikUrl = _urnikUrl;
    this.color = _color;
  }
}

class UserData {
  final String id;
  final String displayName;
  final String givenName;
  final String mail;
  final String mobilePhone;
  final String surname;
  final String userPrincipalName;
  final NetworkImage image;

  const UserData(this.displayName, this.givenName,this.surname, this.mail, this.mobilePhone, this.id, this.userPrincipalName,this.image);
}

class SchoolData {
  String id;
  String urnikUrl;
  String color;
  String schoolUrl;
  String name;
  String razred;
  Color schoolColor;

  Future<void> getData(token) async {
    final response = await http
      .get(Uri.parse('$apiUrl/user/school/'),headers: {"Authorization":token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var decoded = jsonDecode(response.body);
    this.id = decoded["id"].toString();
    this.urnikUrl = decoded["urnikUrl"].toString();
    this.color = decoded["color"].toString();
    this.name = decoded["name"].toString();
    this.razred = decoded["razred"].toString();
    this.schoolUrl = decoded["schoolUrl"].toString();
    if(this.color == "#FFFFFF"){
      this.color = "#000000";
    }
    schoolColor = HexColor.fromHex(this.color);    
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load school data');
  }
  }
}

class Data{

  List<Sola> sole = [
    Sola("ERŠ", "https://ers.scv.si/sl/", "https://ers.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/24353264bf0bc2a4b9c7d30eb8093fc21bb6c766", Color.fromRGBO(0, 148, 217, 1)),
    Sola("ŠSD", "https://storitvena.scv.si/sl/", "https://storitvena.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/642f7c2194b696dce4345e4a06f14d3510784603", Color.fromRGBO(238, 91, 160, 1)),
    Sola("ŠSGO", "https://ssgo.scv.si/sl/", "https://ssgo.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/25447b9cd323fcb5b062a7a450fd3bff7da2b270", Color.fromRGBO(166, 206, 57, 1)),
    Sola("Gimnazija", "https://gimnazija.scv.si/", "https://gimnazija.scv.si/?cat=3", "https://www.easistent.com/urniki/b29317ef35a6e16dc2012e97a575322a8eae7f56", Color.fromRGBO(255, 202, 5, 1))
  ];

  Sola izbranaSola = Sola("ERŠ", "https://ers.scv.si/", "https://ers.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/24353264bf0bc2a4b9c7d30eb8093fc21bb6c766", Colors.blue);

  String selectedId = "ERŠ";
  SchoolData schoolData = new SchoolData();
  UserData user = new UserData("","","","","","","",NetworkImage(""));

  Future<bool> loadData() async{
    final accessToken = await refreshToken();
    if(accessToken == "" || accessToken == null){
      return false;
    }
    this.user = await fetchUserData(accessToken);
    if(user == null){
      return false;
    }
    await this.schoolData.getData(accessToken);

    return true;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}