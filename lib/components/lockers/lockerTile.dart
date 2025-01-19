import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:scv_app/components/confirmAlert.dart';
import 'package:scv_app/components/slideButton.dart';

Widget LockerTile(
    BuildContext context, LockerWithActiveUserResult locker, Function refresh) {
  SliderButtonController controllerOpen = SliderButtonController();
  SliderButtonController controllerEnd = SliderButtonController();

  void openLocker() async {
    OpenLockerResult result = await locker.openLocker();
    controllerOpen.reset();
    if (result.success && result.message != null) {
      refresh();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: Colors.blueGrey,
      ));
    } else if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: Colors.red,
      ));
    }
  }

  void endLocker() async {
    EndLockerResult result = await locker.endLocker();
    controllerEnd.reset();
    if (result.success && result.message != null) {
      refresh();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: Colors.blueGrey,
      ));
    } else if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
        backgroundColor: Colors.red,
      ));
    }
  }

  void showLockerInfo() async {
    UserResult? activeUserData = await locker.fetchUser();
    Dialog dialog = Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        height: 200,
        child: Column(
          children: [
            Text("Omarica: ${locker.lockerIdentifier}"),
            if (locker.activeUser != null)
              Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Omarica je zasedena"),
                    if (activeUserData != null)
                      Text("Uporabnik: ${activeUserData.displayName}"),
                    if (activeUserData != null)
                      Text("Email: ${activeUserData.email}"),
                    Text(
                        "Čas začetka: ${locker.activeUser!.startTime.toLocal()}"),
                    Text("Čas konca: ${locker.activeUser!.endTime?.toLocal()}"),
                  ],
                ),
              ),
            if (locker.activeUser == null) Text("Omarica ni zasedena"),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Omarica", style: TextStyle(fontSize: 20)),
              Text(locker.lockerIdentifier,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              if (locker.activeUser != null)
                Icon(Icons.account_box_outlined, size: 25)
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (locker.activeUser != null)
              Expanded(
                  flex: 1,
                  child: TextButton(
                      onPressed: () {
                        confirmAlert(
                            context,
                            "Ali ste prepričani, da želite končati uporabo omarice in jo odkleniti?",
                            endLocker,
                            () {});
                      },
                      child: Icon(Icons.exit_to_app, size: 30))),
            Expanded(
                flex: 1,
                child: TextButton(
                    onPressed: () {
                      confirmAlert(
                          context,
                          "Ali ste prepričani, da želite odpreti omarico?",
                          openLocker,
                          () {});
                    },
                    child: Icon(Icons.lock_open, size: 30))),
            Expanded(
                flex: 1,
                child: TextButton(
                    onPressed: showLockerInfo,
                    child: Icon(Icons.info_outline, size: 30))),
          ])
        ],
      ));
}
