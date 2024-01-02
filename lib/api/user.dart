import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scv_app/api/school.dart';
import 'package:scv_app/api/status.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id = "";
  String displayName = "";
  String givenName = "";
  String mail = "";
  String mobilePhone = "";
  String surname = "";
  String userPrincipalName = "";
  CachedNetworkImageProvider image = CachedNetworkImageProvider(
      "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png");

  bool loggedIn = true;
  bool logingIn = false;
  bool loading = true;
  bool loadingFromWeb = true;

  School school = new School();
  Status status = new Status();

  User() {
    this.school = new School();
    this.status = new Status();
    this.id = "";
    this.displayName = "";
    this.givenName = "";
    this.mail = "";
    this.mobilePhone = "";
    this.surname = "";
    this.userPrincipalName = "";
    this.loggedIn = true;
    this.logingIn = false;
  }

  Future<void> fetchData() async {
    await global.token.refresh();
    final response = await http.get(Uri.parse(global.apiUrl + "/user/get"),
        headers: {"Authorization": global.token.getAccessToken()});
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      this.fromJSON(json);
      this.loggedIn = true;
      try {
        image = CachedNetworkImageProvider(
            "${global.apiUrl}/user/get/profilePicture?=${json['mail']}",
            headers: {"Authorization": global.token.getAccessToken()},
            errorListener: ((p0) => print(p0)));
      } catch (e) {
        image = CachedNetworkImageProvider(
            "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png");
      }
      this.saveToCache();
    } else {
      throw Exception('Failed to load user');
    }
    this.logingIn = false;
    this.loading = false;
    this.loadingFromWeb = false;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": this.id,
      "displayName": this.displayName,
      "givenName": this.givenName,
      "mail": this.mail,
      "mobilePhone": this.mobilePhone,
      "surname": this.surname,
      "userPrincipalName": this.userPrincipalName,
    };
  }

  void fromJSON(Map<String, dynamic> map) {
    this.id = map['id'];
    this.displayName = map['displayName'];
    this.givenName = map['givenName'];
    this.mail = map['mail'];
    this.mobilePhone = map['mobilePhone'];
    this.surname = map['surname'];
    this.userPrincipalName = map['userPrincipalName'];
  }

  Future<void> saveToCache() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("user", jsonEncode(this.toJSON()));
    } catch (e) {
      global.showGlobalAlert(text: "Napaka pri shranjevanju podatkov.");
    }
  }

  Future<void> loadFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    if (user != null) {
      this.fromJSON(jsonDecode(user));
      this.loading = false;
    }
  }

  Future<void> fetchAll() async {
    await Future.wait([
      this.fetchData(),
      this.school.fetchData(),
      this.status.fetchData(),
    ]);
  }
}
