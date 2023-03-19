import 'package:flutter/material.dart';

Widget MealsSelectedDate() {
  return Center(
      child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.arrow_back_ios,
        size: 35,
      ),
      Text(
        "Izbran datum: 30.2.2022",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      Icon(
        Icons.arrow_forward_ios,
        size: 35,
      ),
    ],
  ));
}
