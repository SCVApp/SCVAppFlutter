import 'package:flutter/material.dart';
import 'package:scv_app/components/malice/selectMeals/selectMenus.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';

import '../../components/malice/selectMeals/selectMenuBox.dart';
import '../../components/malice/selectMeals/selectedDate.dart';

class MaliceSelectMenus extends StatefulWidget {
  MaliceSelectMenus(this.goToHomePage, {Key key}) : super(key: key);
  final Function goToHomePage;
  @override
  _MaliceSelectMenusState createState() => _MaliceSelectMenusState();
}

class _MaliceSelectMenusState extends State<MaliceSelectMenus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            child: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: widget.goToHomePage,
          ),
        ),
        MealsSelectedDate(),
        Padding(padding: EdgeInsets.only(top: 20)),
        MealSelectMenus(context),
      ],
    ));
  }
}
