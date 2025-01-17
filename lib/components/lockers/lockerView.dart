import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/components/slideButton.dart';
import 'package:scv_app/store/AppState.dart';

Widget LockerView(BuildContext context, Locker locker, Function openLocker,
    Function endLocker) {
  SliderButtonController controller = SliderButtonController();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(children: [
            Text("Trenutno imaš rezervirano omarico:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
                textAlign: TextAlign.center),
            Text(locker.identifier,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center),
          ])),
      StoreConnector<AppState, User>(
          converter: (store) => store.state.user,
          builder: (context, user) {
            return Column(children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SliderButton(
                      onSlided: () {
                        endLocker();
                        controller.reset();
                      },
                      text: "Vrni in odpri omarico",
                      backgroundColor: user.school.schoolColor,
                      sliderColor: user.school.schoolSecondaryColor,
                      controller: controller)),
              TextButton(
                  onPressed: () {
                    openLocker();
                  },
                  child: Text("Samo odpri omarico",
                      style: TextStyle(color: user.school.schoolColor)))
            ]);
          }),
    ],
  );
}
