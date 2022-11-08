import 'package:flutter/material.dart';
import 'package:scv_app/Data/functions.dart';

Future<void> showUnAuthoritized(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Napaka, nemorem naložiti podatkov'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Napaka pri nalaganju aplikacije, nimate pravic.'),
              Text(
                  'Prosimo poskusite ponovno naložiti aplikacijo ali se pa poskusite odjaviti. Če nič od tega ne deluje se obrnite na podporo(info.app@scv.si).'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Odjava'),
            onPressed: () {
              logOutUser(context);
            },
          ),
          TextButton(
            child: const Text('Ponovno naloži'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
