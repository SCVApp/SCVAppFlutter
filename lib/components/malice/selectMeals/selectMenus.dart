import 'package:flutter/material.dart';
import 'package:scv_app/components/malice/selectMeals/selectMenuBox.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';

Widget MealSelectMenus(BuildContext context){
  return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            children: [
              MealSelectBox(context),
              Padding(padding: EdgeInsets.only(bottom: 40)),
            ].withSpaceBetween(spacing: 20),
          ),
        );
} 