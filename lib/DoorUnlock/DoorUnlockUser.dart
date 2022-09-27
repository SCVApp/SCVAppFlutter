import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Data/functions.dart';
import '../Data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoorUnlockUserPage extends StatefulWidget {
  DoorUnlockUserPage({Key key, this.data, this.doorCode}) : super(key: key);

  final Data data;
  final String doorCode;

  _DoorUnlockUserPage createState() => _DoorUnlockUserPage();
}

class _DoorUnlockUserPage extends State<DoorUnlockUserPage> {
  @override
  void initState() {
    super.initState();
  }

  ThemeColorForStatus themeColorForStatus = ThemeColorForStatus.unknown;
  bool isLoading = false;

  unlockDoor() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
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
                    "C503",
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
                              Icons.lock_outline,
                              color: this.themeColorForStatus.color,
                              size: MediaQuery.of(context).size.width * 0.3,
                            )
                          : CircularProgressIndicator(
                              color: this.themeColorForStatus.color,
                            ))),
              onTap: unlockDoor),
          !isLoading
              ? Text(
                  "Odklep je na voljo",
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
}
