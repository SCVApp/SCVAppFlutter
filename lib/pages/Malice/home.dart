import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/malice/home/mealInfoBox.dart';
import 'package:scv_app/components/malice/home/todayForMeal.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';

import '../../api/malice/malica.dart';
import '../../store/AppState.dart';

class MaliceHomePage extends StatefulWidget {
  MaliceHomePage(this.goToSelectMenu, this.goToOtherInformations, {Key key})
      : super(key: key);

  final Function goToSelectMenu;
  final Function goToOtherInformations;

  @override
  _MaliceHomePageState createState() => _MaliceHomePageState();
}

class _MaliceHomePageState extends State<MaliceHomePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Malica>(
      converter: (store) => store.state.malica,
      builder: (context, malica) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ListView(
            padding: EdgeInsets.all(10),
            children: [
              TodayForMeal(context),
              MealInfoBox(context, "PIN:", malica.maliceUser.pinNumber),
              MealInfoBox(context, "Malica za jutri:",
                  "Perutničke z medom, dušen riž, solata",
                  textAlignForValue: TextAlign.center),
              MealInfoBox(context, "Stanje na računu:",
                  "${malica.maliceUser.budget.toStringAsFixed(2)}€"),
              MealInfoBox(context, "Naroči za naslednje dni:", "",
                  icon: Icon(Icons.arrow_forward_ios),
                  onTap: widget.goToSelectMenu),
              MealInfoBox(context, "Ostale informacije:", "",
                  icon: Icon(Icons.arrow_forward_ios),
                  onTap: widget.goToOtherInformations),
            ].withSpaceBetween(spacing: 15),
          ),
        );
      },
    );
  }
}
