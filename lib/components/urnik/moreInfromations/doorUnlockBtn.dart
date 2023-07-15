import 'package:flutter/material.dart';
import 'package:scv_app/components/doorPass/CircleProgressBar.dart';

Widget UrnikMoreInformationsDoorUnlockBtn(
    void Function() onTap, bool currentAvailable) {
  return Padding(
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SizedBox(
                child: CircleProgressBar(
                  foregroundColor: currentAvailable ? Colors.green : Colors.red,
                  value: 1,
                  child: Icon(currentAvailable ? Icons.lock_open : Icons.lock,
                      color: currentAvailable ? Colors.green : Colors.red),
                  strokeWidth: 3,
                ),
                width: 45,
                height: 45,
              ),
              Padding(padding: EdgeInsets.only(left: 15)),
              Text(
                "ODKLEP VRAT JE NA VOLJO",
                style: TextStyle(
                    color: currentAvailable ? Colors.green : Colors.red),
              )
            ]),
            Icon(
              Icons.arrow_forward_ios,
              color: currentAvailable ? Colors.green : Colors.red,
              size: 25,
            )
          ],
        ),
        onTap: onTap,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5));
}
