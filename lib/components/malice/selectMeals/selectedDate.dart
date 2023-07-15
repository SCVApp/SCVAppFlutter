import 'package:flutter/material.dart';

Widget MealsSelectedDate(void Function() toggleCalander) {
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
      GestureDetector(child:
      Text(
        "Izbran datum: 30.2.2022",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),onTap: toggleCalander,),
      Icon(
        Icons.arrow_forward_ios,
        size: 35,
      ),
    ],
  ));
}
