import 'dart:convert';
import 'dart:io';

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
  final UserStatusData status;

  const UserData(this.displayName, this.givenName,this.surname, this.mail, this.mobilePhone, this.id, this.userPrincipalName,this.image,this.status);
}

class UserStatusData{
  String id;
  String display;
  String color;
  AssetImage assetImage;

  Future<void> getData(token) async{
    final response = await http
      .get(Uri.parse('$apiUrl/user/get/status'),headers: {"Authorization":token});

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      this.id = decoded["id"];
      this.display = decoded["display"];
      this.color = decoded["color"];
      this.assetImage = AssetImage("assets/statusIcons/${this.id}.png");
    }
  }

  setS(UserStatusData nev){
    this.id = nev.id;
    this.display = nev.display;
    this.color = nev.color;
    this.assetImage = nev.assetImage;
  }

  Future<UserStatusData> setStatus(String statusId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(keyForAccessToken);
    final response = await http
      .get(Uri.parse('$apiUrl/user/setStatus/$statusId'),headers: {"Authorization":accessToken});
    if(response.statusCode == 200){
      await this.getData(accessToken);
    }
    return this;
  }
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
      this.color = "#8253D7";
    }
    schoolColor = HexColor.fromHex(this.color);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load school data');
  }
  }
}

class CacheData{
  String schoolUrlKey = "cacheData-SchoolUrl";
  String schoolUrl;
  String schoolColorKey = "cacheData-SchoolColor";
  Color schoolColor;
  String userDisplayNameKey = "cacheData-UserDisplayName";
  String userDisplayName;
  String userMailKey = "cacheData-UserDisplayMail";
  String userMail;
  String schoolScheduleKey= "cacheData-SchoolSchedule";
  String schoolSchedule;

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      this.schoolUrl = prefs.getString(this.schoolUrlKey);
      this.schoolColor = HexColor.fromHex(prefs.getString(this.schoolColorKey));
      this.userDisplayName = prefs.getString(this.userDisplayNameKey);
      this.userMail = prefs.getString(this.userMailKey);
      this.schoolSchedule = prefs.getString(this.schoolScheduleKey);
    }catch (e){
      this.schoolUrl = "";
      this.schoolColor = Colors.blue;
      this.userDisplayName = "Not loaded";
      this.userMail = "not.loaded@scv.si";
      this.schoolSchedule = "";
    }
  }

  saveData(String _schoolUrl, String _schoolColorHex, String _userDisplayName, String _userMail, String _schoolSchedule) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.schoolUrlKey, _schoolUrl);
    this.schoolUrl = _schoolUrl;
    prefs.setString(this.schoolColorKey, _schoolColorHex);
    this.schoolColor = HexColor.fromHex(_schoolColorHex);
    prefs.setString(this.userDisplayNameKey, _userDisplayName);
    this.userDisplayName = _userDisplayName;
    prefs.setString(this.userMailKey, _userMail);
    this.userMail = _userMail;
    prefs.setString(this.schoolScheduleKey, _schoolSchedule);
    this.schoolSchedule = _schoolSchedule;
  }

  deleteKeys(SharedPreferences prefs){
    prefs.remove(this.schoolUrlKey);
    prefs.remove(this.schoolColorKey);
    prefs.remove(this.userDisplayNameKey);
    prefs.remove(this.userMailKey);
    prefs.remove(this.schoolScheduleKey);
  }
}

class Data{
  SchoolData schoolData = new SchoolData();
  UserData user = new UserData("","","","","","","",NetworkImage(""),UserStatusData());

  Future<bool> loadData(CacheData cacheData) async{
    final accessToken = await refreshToken();
    if(accessToken == "" || accessToken == null){
      return false;
    }
    this.user = await fetchUserData(accessToken);
    if(user == null){
      return false;
    }
    await this.schoolData.getData(accessToken);
    cacheData.saveData(this.schoolData.schoolUrl,this.schoolData.color,this.user.displayName,this.user.mail,this.schoolData.urnikUrl);
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