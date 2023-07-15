import 'package:flutter/material.dart';
import 'package:scv_app/api/malice/malicaDan.dart';
import 'package:scv_app/api/malice/malicaMeni.dart';
import 'package:scv_app/api/malice/malicaTipMeni.dart';
import 'package:scv_app/components/malice/mealsBoxDecoration.dart';
import 'package:collection/collection.dart';

Widget MealSelectBox(BuildContext context, MalicaDan? dan, MalicaMeni? meni,
    {bool isSelected = false}) {
  MalicaTipMeni? tip = dan?.tipiMenijev
      .firstWhereOrNull((element) => element.id == meni?.tip_id);
  return Container(
    decoration: mealsBoxDecoration(context, isSelected: isSelected),
    padding: EdgeInsets.all(15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Image(image: AssetImage(MalicaDan.getPictureUrl(tip)))),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          MalicaDan.getOpisMenija(meni),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
