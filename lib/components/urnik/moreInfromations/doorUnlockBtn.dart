import 'package:flutter/material.dart';
import 'package:scv_app/components/doorPass/CircleProgressBar.dart';

Widget UrnikMoreInformationsDoorUnlockBtn() {
  return Padding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SizedBox(
              child: CircleProgressBar(
                foregroundColor: Colors.green,
                value: 1,
                child: Icon(Icons.lock_open, color: Colors.green),
                strokeWidth: 3,
              ),
              width: 45,
              height: 45,
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            Text(
              "ODKLEP VRAT JE NA VOLJO",
              style: TextStyle(color: Colors.green),
            )
          ]),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.green,
            size: 25,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5));
}
