import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Data/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/data.dart';
import 'package:http/http.dart' as http;
import '../Intro_And__Login/prijava.dart';

class DoorUnlockUserPage extends StatefulWidget {
  DoorUnlockUserPage({Key key, this.data, this.url}) : super(key: key);

  final Data data;
  final String url;

  _DoorUnlockUserPage createState() => _DoorUnlockUserPage();
}

class _DoorUnlockUserPage extends State<DoorUnlockUserPage> {
  @override
  void initState() {
    super.initState();
    checkUri();
  }

  ThemeColorForStatus themeColorForStatus = ThemeColorForStatus.unknown;
  bool isLoading = false;
  String doorCode = '';

  String doorNameId = '';

  void checkUri() {
    if (isUrlForOpeinDoor(widget.url)) {
      this.doorCode =
          widget.url.replaceFirst("scvapp://app.scv.si/open_door/", "");
      if (doorCode != "" && doorCode != null) {
        this.unlockDoor();
        this.getDoorInfo();
      } else {
        Navigator.of(context).pop();
      }
    } else {
      print("Not a valid url");
      Navigator.of(context).pop();
    }
  }

  void getDoorInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(keyForAccessToken);
    final respons = await http
        .get(Uri.parse("$apiUrl/pass/get_door/${this.doorCode}"), headers: {
      'Authorization': '$accessToken',
    });
    if (respons.statusCode == 200) {
      this.doorNameId = respons.body ?? "";
    }
  }

  unlockDoor() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(keyForAccessToken);
    final respons = await http
        .get(Uri.parse("$apiUrl/pass/open_door/${this.doorCode}"), headers: {
      'Authorization': '$accessToken',
    });
    if (respons.statusCode == 200) {
      setState(() {
        themeColorForStatus = ThemeColorForStatus.success;
        isLoading = false;
      });
      return;
    } else {
      final body = jsonDecode(respons.body);
      final message = body["message"];
      if (message == "Door not found") {
        setState(() {
          themeColorForStatus = ThemeColorForStatus.error;
          isLoading = false;
        });
      } else if (message == "User doesn't have access to this door") {
        setState(() {
          themeColorForStatus = ThemeColorForStatus.promisson_denied;
          isLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        backButton(context),
        Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
            child: ListView(
                children: [
          Padding(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Izbrana učilnica:",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "${this.doorNameId}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 70)),
          GestureDetector(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.width * 0.65,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                          color: this.themeColorForStatus.color, width: 20)),
                  child: Center(
                      child: !isLoading
                          ? Icon(
                              this.themeColorForStatus.icon,
                              color: this.themeColorForStatus.color,
                              size: MediaQuery.of(context).size.width * 0.3,
                            )
                          : CircularProgressIndicator(
                              color: this.themeColorForStatus.color,
                            ))),
              onTap: unlockDoor),
          !isLoading
              ? Text(
                  this.themeColorForStatus.message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
              : SizedBox(),
          !isLoading
              ? Text("Pritisni ključavnico za odklep",
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center)
              : SizedBox(),
        ].withSpaceBetween(spacing: 30))),
      ],
    )));
  }
}

enum ThemeColorForStatus {
  success,
  promisson_denied,
  error,
  unknown,
}

extension ThemeColorForStatusExtension on ThemeColorForStatus {
  Color get color {
    switch (this) {
      case ThemeColorForStatus.success:
        return Colors.green;
      case ThemeColorForStatus.promisson_denied:
        return Colors.orange;
      case ThemeColorForStatus.error:
        return Colors.red;
      case ThemeColorForStatus.unknown:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeColorForStatus.success:
        return Icons.lock_open_outlined;
      case ThemeColorForStatus.promisson_denied:
        return Icons.lock_outline;
      case ThemeColorForStatus.error:
        return Icons.lock_outline;
      case ThemeColorForStatus.unknown:
        return Icons.lock_outline;
      default:
        return Icons.lock_outline;
    }
  }

  String get message {
    switch (this) {
      case ThemeColorForStatus.success:
        return "Vrata so uspešno odklenjena";
      case ThemeColorForStatus.promisson_denied:
        return "Trenutno nimaš pouka v tej učilnici";
      case ThemeColorForStatus.error:
        return "Učilnica ne obstaja";
      case ThemeColorForStatus.unknown:
        return "Neznana napaka";
      default:
        return "Neznana napaka";
    }
  }
}
