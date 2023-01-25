import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/alertContainer.dart';
import 'package:scv_app/components/backButton.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/components/nastavitve/changeStatusPage/statusItem.dart';
import 'package:scv_app/store/AppState.dart';

import '../../api/user.dart';
import '../../components/nastavitve/nastavitveGroup.dart';
import '../../components/nastavitve/profilePictureWithStatus.dart';

class ChangeStatusPage extends StatefulWidget {
  @override
  _ChangeStatusPageState createState() => _ChangeStatusPageState();
}

class _ChangeStatusPageState extends State<ChangeStatusPage> {
  bool isLoading = false;

  Future<void> changeStatus(String statusId) async {
    setState(() {
      isLoading = true;
    });
    User user = StoreProvider.of<AppState>(context).state.user;
    await user.status.changeStatus(statusId);
    StoreProvider.of<AppState>(context).dispatch(user);
    setState(() {
      isLoading = false;
    });
  }

  List<StatusItem> status = [
    StatusItem(
      title: "Dosegljiv/-a",
      imageProvider: AssetImage("assets/images/statusIcons/available.png"),
      statusId: "available",
    ),
    StatusItem(
      title: "Odsoten/-a",
      imageProvider: AssetImage("assets/images/statusIcons/away.png"),
      statusId: "away",
    ),
    StatusItem(
      title: "Takoj bom nazaj",
      imageProvider: AssetImage("assets/images/statusIcons/brb.png"),
      statusId: "brb",
    ),
    StatusItem(
      title: "Zaseden/-a",
      imageProvider: AssetImage("assets/images/statusIcons/busy.png"),
      statusId: "busy",
    ),
    StatusItem(
      title: "Ne moti",
      imageProvider: AssetImage("assets/images/statusIcons/dnd.png"),
      statusId: "dnd",
    ),
    StatusItem(
      title: "Nedosegljiv/-a",
      imageProvider: AssetImage("assets/images/statusIcons/offline.png"),
      statusId: "offline",
    ),
  ];

  List<StatusItem> listOfStatus() {
    return status.map((StatusItem statusItem) {
      statusItem.onTap = (() => changeStatus(statusItem.statusId));
      return statusItem;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return Scaffold(
          body: SafeArea(
              child: Column(children: [
            // crossAxisAlignment: CrossAxisAlignment.center,
            backButton(context),
            isLoading
                ? Text("")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfilePictureWithStatus(context),
                    ],
                  ),
            Padding(padding: EdgeInsets.only(top: 10)),
            isLoading
                ? Text("")
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40, top: 10),
                      child: Text(
                        "Izberi prikazan status:",
                        style: TextStyle(
                            fontSize:
                                22 * MediaQuery.of(context).textScaleFactor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            Padding(padding: EdgeInsets.only(top: 10)),
            isLoading
                ? loadingItem(user.school.schoolColor)
                : Expanded(
                    child: ListView(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    children: [
                      NastavitveGroup(items: listOfStatus()),
                    ],
                  )),
          ])),
          bottomSheet: AlertContainer(),
        );
      },
    );
  }
}
