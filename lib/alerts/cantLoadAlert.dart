import 'package:flutter/material.dart';

Future<void> showCantLoad(BuildContext context, Function restartApp) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
            'Napaka, aplikacija ne more naložiti podatkov is spleta.'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Napaka pri nalaganju aplikacije, poskusite znova.'),
              Text(
                  'Preverite ali imate internetno povezavo. Če napaka ostane, se obrnite na podporo (info.app@scv.si)'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Poskusi znova'),
            onPressed: () {
              Navigator.of(context).pop();
              restartApp();
            },
          ),
        ],
      );
    },
  );
}
