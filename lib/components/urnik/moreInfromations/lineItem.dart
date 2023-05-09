import 'package:flutter/material.dart';

Widget UrnikMoreInformationsLineItem(IconData icon, String title, String text) {
  return Padding(
    child: Row(
      children: [
        Icon(
          icon,
          size: 50,
        ),
        SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(text)
          ],
        )
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
  );
}
