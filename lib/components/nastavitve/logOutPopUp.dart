import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/global/global.dart' as global;

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
        title: const Text('Odjava'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                'Si prepričan, da se želiš odjaviti iz aplikacije ŠCVApp?',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Ne, prekliči'),
              onPressed: () => Navigator.pop(context, 'Cancel')),
          TextButton(
              child: const Text('Da, odjavi me.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: odjava),
        ],
      );
    },
  );
}
