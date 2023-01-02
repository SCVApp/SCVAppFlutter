import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/pages/Urnik/style.dart';
import 'package:scv_app/store/AppState.dart';

Widget mainTitle() {
  return StoreConnector<AppState, Urnik>(
    converter: (store) => store.state.urnik,
    builder: (context, urnik) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text(
            "Trenutno na urniku",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.only(left: 5)),
          urnik.poukType != PoukType.konecPouka
              ? Text(
                  "(${urnik.doNaslednjeUre} do ${UrnikStyle.mainTitle(urnik.poukType)}):",
                )
              : SizedBox(),
        ],
      );
    },
  );
}
