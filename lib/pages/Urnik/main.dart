import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/components/urnik/mainTitle.dart';
import 'package:scv_app/components/urnik/seeOtherDays.dart';
import 'package:scv_app/components/urnik/titleBox.dart';
import 'package:scv_app/components/urnik/viewForObdobjaUr.dart';
import 'package:scv_app/components/urnik/viewForObdobjeUre.dart';
import 'package:scv_app/pages/Urnik/style.dart';
import 'package:scv_app/store/AppState.dart';

class UrnikPage extends StatefulWidget {
  @override
  _UrnikPageState createState() => _UrnikPageState();
}

class _UrnikPageState extends State<UrnikPage> {
  final double gap = 15;
  late Timer timerZaUrnik;

  @override
  void initState() {
    super.initState();
    timerZaUrnik =
        Timer.periodic(Duration(seconds: 1), (Timer t) => refreshUrnik());
  }

  @override
  void dispose() {
    super.dispose();
    if (timerZaUrnik != null) {
      timerZaUrnik.cancel();
    }
  }

  void refreshUrnik() {
    Urnik urnik = StoreProvider.of<AppState>(context).state.urnik;
    urnik.setTypeForObdobjaUr();
    StoreProvider.of<AppState>(context).dispatch(urnik);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Urnik>(
        converter: (store) => store.state.urnik,
        builder: (context, urnik) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                  child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(bottom: 5)),
                  Padding(
                      child: mainTitle(),
                      padding: EdgeInsets.only(
                          bottom: this.gap, left: 25, right: 25)),
                  urnik.poukType == PoukType.pouk && urnik.obdobjaUr.length > 0
                      ? ViewForObdobjeUre(
                          viewSizes: UrnikStyle.viewStyleBig,
                          obdobjeUr: urnik.obdobjaUr.firstWhere((obdobjeUr) =>
                              obdobjeUr.type == ObdobjaUrType.trenutno),
                        )
                      : Padding(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: titleBox()),
                  Padding(padding: EdgeInsets.only(bottom: this.gap)),
                  seeOtherDays(gap, context),
                  Padding(
                    child: Align(
                      child: Text(
                        "Današnji urnik",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    padding:
                        EdgeInsets.only(bottom: this.gap, left: 15, right: 15),
                  ),
                  ViewForObdobjaUr(
                    gap: this.gap,
                  ),
                ],
              )),
            ),
          );
        });
  }
}
