import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/components/urnik/viewForObdobjeUre.dart';
import 'package:scv_app/pages/Urnik/style.dart';
import 'package:scv_app/store/AppState.dart';

Widget viewForObdobjaUr(double gap) {
  return StoreConnector<AppState, Urnik>(
      converter: (store) => store.state.urnik,
      builder: (context, urnik) {
        return Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              child: ViewForObdobjeUre(
                  obdobjeUr: urnik.obdobjaUr[index],
                  viewSizes: UrnikStyle.viewStyleSmall),
              padding: EdgeInsets.only(bottom: gap),
            );
          },
          itemCount: urnik.obdobjaUr.length,
        ));
      });
}
