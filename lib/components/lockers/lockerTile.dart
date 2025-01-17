import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:scv_app/components/slideButton.dart';

Widget LockerTile(BuildContext context, LockerWithActiveUserResult locker) {
  SliderButtonController controllerOpen = SliderButtonController();
  SliderButtonController controllerEnd = SliderButtonController();

  void openLocker() async {
    OpenLockerResult result = await locker.openLocker();
    controllerOpen.reset();
    if (result.success && result.message != null) {
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

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text("Omarica: ${locker.lockerIdentifier}",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      if (locker.activeUser != null)
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SliderButton(
                onSlided: endLocker,
                text: "Vrni omarico",
                controller: controllerEnd)),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SliderButton(
              onSlided: openLocker,
              text: "Odpri omarico",
              controller: controllerOpen)),
    ],
  );
}
