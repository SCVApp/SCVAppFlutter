import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scv_app/global/global.dart' as global;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Status {
  String id = "unknown";
  String display = "Unknown";
  String color = "#FFFFFF";
  AssetImage assetImage = AssetImage("assets/images/statusIcons/unknown.png");

  Status() {
    this.id = "unknown";
    this.display = "Unknown";
    this.color = "#FFFFFF";
    this.assetImage = AssetImage("assets/images/statusIcons/unknown.png");
  }

  void fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    display = json['display'];
    color = json['color'];
    try {
      assetImage = AssetImage("assets/images/statusIcons/" + id + ".png");
    } catch (e) {
      assetImage = AssetImage("assets/images/statusIcons/unknown.png");
    }
  }

  Future<void> fetchData() async {
    await global.token.refresh();
    final response = await http.get(
        Uri.parse(global.apiUrl + "/user/get/status"),
        headers: {"Authorization": global.token.getAccessToken()});
    if (response.statusCode == 200) {
      this.fromJSON(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load status');
    }
  }

  Future<void> changeStatus(String statusId) async {
    await global.token.refresh();
    try {
      final response = await http.get(
          Uri.parse('${global.apiUrl}/user/setStatus/$statusId'),
          headers: {"Authorization": global.token.getAccessToken()});
      if (response.statusCode == 200) {
        await this.fetchData();
        global.showGlobalAlert(text: "Status uspešno spremenjen");
      } else {
        throw Exception('Failed to change status');
      }
    } catch (e) {
      global.showGlobalAlert(
          text: AppLocalizations.of(global.globalBuildContext)!
              .error_status_load);
    }
  }
}
