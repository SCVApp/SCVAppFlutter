import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../api/user.dart';
import '../../store/AppState.dart';

Future<void> logOutPopup(BuildContext context) async {
  void odjava() {
    global.logOutUser(context);
    final User user = StoreProvider.of<AppState>(context).state.user;
    user.loggedIn = false;
    StoreProvider.of<AppState>(context).dispatch(user);
    Navigator.pop(context, 'Cancel');
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text((AppLocalizations.of(context)!.logout)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                 (AppLocalizations.of(context)!.prompt_logout),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: Text(AppLocalizations.of(context)!.no_cancel),
              onPressed: () => Navigator.pop(context, 'Cancel')),
          TextButton(
              child: Text(AppLocalizations.of(context)!.confirm_logout,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: odjava),
        ],
      );
    },
  );
}
