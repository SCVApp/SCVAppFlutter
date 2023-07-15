import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;

class EPASUserListItem {
  String azureId = "";
  bool attended = false;
  String displayName = "";

  static EPASUserListItem fromJson(Map<String, dynamic> json) {
    EPASUserListItem item = EPASUserListItem();
    item.azureId = json["azureId"];
    item.attended = json["attended"];
    return item;
  }

  Future<void> getUsername() async {
    try {
      final response = await http.get(
          Uri.parse("${global.apiUrl}/search/specificUser/$azureId"),
          headers: {
            'Authorization': '${global.token.getAccessToken()}',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        this.displayName = data["displayName"];
      }
    } catch (e) {}
  }
}
