import 'package:flutter/material.dart';
import 'package:scv_app/components/malice/mealsBoxDecoration.dart';

Widget MealSelectBox(BuildContext context) {
  return Container(
    decoration: mealsBoxDecoration(context),
    padding: EdgeInsets.all(15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Image(
                image: AssetImage("assets/images/slikeMalica/mesni_meni.png"))),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          "Perutničke z medom, dušen riž, solata",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
