import 'package:flutter/material.dart';
import 'package:scv_app/components/malice/selectMeals/selectDateCalander.dart';
import 'package:scv_app/components/malice/selectMeals/selectMenus.dart';

import '../../components/malice/selectMeals/selectedDate.dart';

class MaliceSelectMenus extends StatefulWidget {
  MaliceSelectMenus(this.goToHomePage, {Key? key}) : super(key: key);
  final void Function() goToHomePage;
  @override
  _MaliceSelectMenusState createState() => _MaliceSelectMenusState();
}

class _MaliceSelectMenusState extends State<MaliceSelectMenus> {
  bool isCalanderOpen = false;
  int selectedDate = 2;

  void toggleCalander() {
    setState(() {
      isCalanderOpen = !isCalanderOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.bottomCenter, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              child: Icon(Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColor),
              onPressed: widget.goToHomePage,
            ),
          ),
          MealsSelectedDate(toggleCalander),
          Padding(padding: EdgeInsets.only(top: 20)),
          MealSelectMenus(context, selectedDate),
        ],
      ),
      Positioned(
        child: isCalanderOpen ? MealsSelectDateCalander(context) : SizedBox(),
        height: MediaQuery.of(context).size.height / 2,
      )
    ]));
  }
}
