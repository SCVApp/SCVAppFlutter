import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/pages/Urnik/style.dart';
import 'package:scv_app/store/AppState.dart';

Widget titleBox() {
  return StoreConnector<AppState, User>(
    converter: (store) => store.state.user,
    builder: (context, user) {
      return Container(
          height: UrnikStyle.viewStyleBig.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: user.school.schoolColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [UrnikStyle.mainTitleForBox()],
          ));
    },
  );
}
