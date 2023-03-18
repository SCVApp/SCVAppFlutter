import 'package:flutter/material.dart';
import 'package:scv_app/components/malice/mealsBoxDecoration.dart';

Widget TodayForMeal(BuildContext context) {
  return Container(
    decoration: mealsBoxDecoration(context),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
        Text(
          "IZBRANA MALICA ZA DANES:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            child: Image(
                image: AssetImage("assets/images/slikeMalica/mesni_meni.png"))),
        Text(
          "Ragu stroganov, testenine, solata",
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
      ],
    ),
  );
}
