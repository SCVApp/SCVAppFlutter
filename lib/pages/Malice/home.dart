import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/malice/home/mealInfoBox.dart';
import 'package:scv_app/components/malice/home/todayForMeal.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';

import '../../api/malice/malica.dart';
import '../../api/malice/malicaDan.dart';
import '../../api/malice/malicaMeni.dart';
import '../../store/AppState.dart';

class MaliceHomePage extends StatefulWidget {
  MaliceHomePage(this.goToSelectMenu, this.goToOtherInformations, {Key? key})
      : super(key: key);

  final void Function() goToSelectMenu;
  final void Function() goToOtherInformations;

  @override
  _MaliceHomePageState createState() => _MaliceHomePageState();
}

class _MaliceHomePageState extends State<MaliceHomePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Malica>(
      converter: (store) => store.state.malica,
      builder: (context, malica) {
        MalicaDan? dan = malica.getDay(0);
        MalicaMeni? meni = dan?.getSelectedMenu();
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ListView(
            padding: EdgeInsets.all(10),
            children: [
              TodayForMeal(context),
              MealInfoBox(context, "PIN:", malica.maliceUser.pinNumber),
              MealInfoBox(
                  context, "Malica za jutri:", MalicaDan.getOpisMenija(meni),
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
