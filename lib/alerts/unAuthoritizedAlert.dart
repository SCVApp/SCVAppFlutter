import 'package:flutter/material.dart';
import 'package:scv_app/Data/functions.dart';
import 'package:restart_app/restart_app.dart';

Future<void> showUnAuthoritized(BuildContext context, Function resetApp) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext _context) {
      return AlertDialog(
        title: const Text('Napaka, nemorem naložiti podatkov'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Napaka, pridobivanje podatkov je bilo neuspešno.'),
              Text(
                  'Aplikacija se ni naložila zaradi primanjkanja pravic. Prosim, ponovno naloži aplikacijo. Če problem ni odpravljen po nekaj poskusih, se prosim obrni na podporo (info.app@scv.si).'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Odjava'),
            onPressed: () {
              Navigator.pop(_context);
              logOutUser(context);
            },
          ),
          TextButton(
              child: const Text('Ponovno naloži'),
              onPressed: () {
                Navigator.pop(_context);
                resetApp();
              }),
        ],
      );
    },
  );
}
