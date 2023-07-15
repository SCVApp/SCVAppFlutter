import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/malice/malicaDan.dart';
import 'package:scv_app/api/malice/malicaMeni.dart';
import 'package:scv_app/api/malice/malicaTipMeni.dart';
import 'package:scv_app/components/malice/mealsBoxDecoration.dart';

import '../../../api/malice/malica.dart';
import '../../../store/AppState.dart';

Widget TodayForMeal(BuildContext context) {
  return StoreConnector<AppState, Malica>(
      converter: (store) => store.state.malica,
      builder: (context, malica) {
        MalicaDan? dan = malica.getDay(0);
        MalicaMeni? meni = dan?.getSelectedMenu();
        MalicaTipMeni? tipMenija = dan?.getTipMenija(meni);
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
                      image: AssetImage(MalicaDan.getPictureUrl(tipMenija)))),
              Text(
                MalicaDan.getOpisMenija(meni),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
            ],
          ),
        );
      });
}
