import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/components/backButton.dart';
import 'package:scv_app/components/doorPass/CircleProgressBar.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';
import 'package:scv_app/manager/universalLinks.dart' as universalLinks;
import 'package:scv_app/pages/PassDoor/status.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:scv_app/store/AppState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnlockedPassDoor extends StatefulWidget {
  @override
  _UnlockedPassDoorState createState() => _UnlockedPassDoorState();
}

class _UnlockedPassDoorState extends State<UnlockedPassDoor>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> procentageAnimation;

  @override
  void initState() {
    super.initState();
    this.animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    this.procentageAnimation =
        Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.addListener(() {
      setState(() {});
    });
    //After build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.checkUri();
    });
  }

  @override
  void dispose() {
    this.animationController.dispose();
    super.dispose();
  }

  ThemeColorForStatus themeColorForStatus = ThemeColorForStatus.unknown;
  bool isLoading = false;
  String doorCode = '';
  bool isAlertShown = false;

  String doorNameId = '';

  void checkUri() async {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    final attributes = windowManager.getAttributes("PassDoor");

    if (attributes == {}) {
      close();
      return;
    }

    final String uri = attributes["uri"] ?? "";

    if (universalLinks.chechURI(uri)) {
      this.doorCode = uri.replaceFirst("scvapp://app.scv.si/open_door/", "");
      await global.token.refresh();
      this.getDoorInfo();
      this.unlockDoor();
    }
  }

  void getDoorInfo() async {
    final respons = await http.get(
        Uri.parse("${global.apiUrl}/pass/get_door/${this.doorCode}"),
        headers: {
          'Authorization': '${global.token.getAccessToken()}',
        });
    if (respons.statusCode == 200) {
      this.doorNameId = respons.body ?? this.doorNameId;
    }
  }

  void unlockDoor() async {
    if (this.themeColorForStatus == ThemeColorForStatus.error ||
        this.themeColorForStatus == ThemeColorForStatus.success) {
      return;
    }
    setState(() {
      this.themeColorForStatus = ThemeColorForStatus.unknown;
      isLoading = true;
    });
    final respons = await http.get(
        Uri.parse("${global.apiUrl}/pass/open_door/${this.doorCode}"),
        headers: {
          'Authorization': '${global.token.getAccessToken()}',
        });
    if (respons.statusCode == 200) {
      setStatus(ThemeColorForStatus.success);
      this.animationController.forward().whenComplete(() {
        setState(() {
          this.themeColorForStatus = ThemeColorForStatus.lock_status;
          this.animationController.reset();
        });
      });
      return;
    } else {
      final body = jsonDecode(respons.body);
      final message = body["message"];
      if (message == "Door not found") {
        setStatus(ThemeColorForStatus.error);
        ShowError(
          (AppLocalizations.of(context)!.door_not_found),
        );
      } else if (message == "User doesn't have access to this door") {
        setStatus(ThemeColorForStatus.promisson_denied);
      } else if (message == "User is in timeout") {
        setStatus(ThemeColorForStatus.time_out);
      } else if (message == "Door not opened") {
        setStatus(ThemeColorForStatus.door_not_opened);
      } else {
        setStatus(ThemeColorForStatus.unknown);
        ShowError(AppLocalizations.of(context)!.something_went_wrong);
      }
      return;
    }
  }

  void setStatus(ThemeColorForStatus status) {
    setState(() {
      this.themeColorForStatus = status;
      isLoading = false;
    });
  }

  Future<void> ShowError(String napaka, {bool closeInTheEnd = false}) async {
    if (isAlertShown) return;
    isAlertShown = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext contextOfDialog) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text("$napaka"),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(contextOfDialog, 'Cancel');
                  if (closeInTheEnd) {
                    close();
                  }
                }),
          ],
        );
      },
    );
  }

  void close() {
    if (!mounted) return;
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    windowManager.hideWindow("PassDoor");
    StoreProvider.of<AppState>(context).dispatch(windowManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        backButton(context, onPressed: close),
        Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
            child: ListView(
                children: [
          Padding(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    (AppLocalizations.of(context)!.selected_classroom),
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
                child: CircleProgressBar(
                  foregroundColor: ThemeColorForStatus.error.color,
                  value: this.procentageAnimation.value ?? 1,
                  backgroundColor: this.themeColorForStatus.color,
                  strokeWidth: 20,
                  child: !isLoading
                      ? Icon(
                          this.themeColorForStatus.icon,
                          color: this.themeColorForStatus.color,
                          size: MediaQuery.of(context).size.width * 0.3,
                        )
                      : CircularProgressIndicator(
                          color: this.themeColorForStatus.color,
                        ),
                ),
              ),
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
              ? Text(this.themeColorForStatus.infoMessage,
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center)
              : SizedBox(),
        ].withSpaceBetween(spacing: 30))),
      ],
    )));
  }
}
