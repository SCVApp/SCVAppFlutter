import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> confirmAlert(BuildContext context, String text,
    Function confirmFunction, Function discardFunction) async {
  void yesFunction() {
    Navigator.of(context).pop();
    confirmFunction();
  }

  void noFunction() {
    Navigator.of(context).pop();
    discardFunction();
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Opozorilo!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: yesFunction),
          TextButton(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: noFunction),
        ],
      );
    },
  );
}
