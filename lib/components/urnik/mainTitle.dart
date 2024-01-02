import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/pages/Urnik/style.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget mainTitle() {
  return StoreConnector<AppState, Urnik>(
    converter: (store) => store.state.urnik,
    builder: (context, urnik) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.now_on_schedule,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.only(left: 5)),
          urnik.poukType != PoukType.konecPouka &&
                  urnik.poukType != PoukType.niPouka
              ? Text(
                  "(${urnik.doNaslednjeUre} ${AppLocalizations.of(context)!.until} ${urnik.obdobjaUr.firstWhereOrNull((obdobjeUr) => obdobjeUr.type == ObdobjaUrType.naslednje) != null ? UrnikStyle.mainTitle(urnik.poukType) : AppLocalizations.of(context)!.end_of_schedule}):",
                )
              : SizedBox(),
        ],
      );
    },
  );
}
