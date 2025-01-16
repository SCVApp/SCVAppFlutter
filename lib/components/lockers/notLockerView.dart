import 'package:flutter/material.dart';

Widget NotLockerView(BuildContext context, onTap) {
  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
    Text("Trenutno nimaš izbrane omarice",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        textAlign: TextAlign.center),
    TextButton(
      onPressed: onTap,
      child: Text("Dodeli mi omarico",
          style: Theme.of(context).textTheme.bodyLarge),
    ),
  ]);
}
