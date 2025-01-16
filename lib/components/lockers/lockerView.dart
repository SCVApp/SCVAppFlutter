import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';

Widget LockerView(BuildContext context, Locker locker, Function openLocker,
    Function endLocker) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text("Tvoja omarica",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      Text("Omarica: ${locker.identifier}",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      OutlinedButton(
        onPressed: () {
          endLocker();
        },
        child: Text("Vrni omarico"),
      ),
      TextButton(
        onPressed: () {
          openLocker();
        },
        child: Text("Odpri omarico"),
      ),
    ],
  );
}
