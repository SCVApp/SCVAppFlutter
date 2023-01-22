import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
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
          urnik.poukType != PoukType.konecPouka &&
                  urnik.poukType != PoukType.niPouka
              ? Text(
                  "(${urnik.doNaslednjeUre} do ${urnik.obdobjaUr.firstWhere(
                        (obdobjeUr) =>
                            obdobjeUr.type == ObdobjaUrType.naslednje,
                        orElse: () => null,
                      ) != null ? UrnikStyle.mainTitle(urnik.poukType) : "konca pouka"}):",
                )
              : SizedBox(),
        ],
      );
    },
  );
}
