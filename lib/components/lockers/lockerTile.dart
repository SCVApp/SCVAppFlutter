import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/components/slideButton.dart';

Widget LockerTile(BuildContext context, LockerWithActiveUserResult locker) {
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
            child: SliderButton(onSlided: () {}, text: "Vrni omarico")),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SliderButton(onSlided: () {}, text: "Odpri omarico")),
    ],
  );
}
