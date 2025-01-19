import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/components/slideButton.dart';
import 'package:scv_app/store/AppState.dart';

Widget NotLockerView(BuildContext context, onTap) {
  SliderButtonController controller = SliderButtonController();

  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Trenutno nimaš rezervirane omarice",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center)),
        StoreConnector<AppState, User>(
            converter: (store) => store.state.user,
            builder: (context, user) {
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SliderButton(
                      onSlided: () {
                        onTap();
                        controller.reset();
                      },
                      text: "Rezerviraj in odpri omarico",
                      backgroundColor: user.school.schoolColor,
                      sliderColor: user.school.schoolSecondaryColor,
                      controller: controller));
            })
      ]);
}
