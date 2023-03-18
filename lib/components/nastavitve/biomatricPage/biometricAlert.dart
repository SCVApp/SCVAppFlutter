import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

Future<void> biometricAlert(BuildContext context,
    {List<Widget> actions, String text}) async {
      void pojdiVNastavitve() {
    Navigator.pop(context);
    AppSettings.openSecuritySettings();
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
              Text(text ?? "Napaka"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Prekliči'),
              onPressed: () => Navigator.pop(context)),
              TextButton(
                  child: const Text('Odpri nastavitve',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: pojdiVNastavitve),
          ...actions ?? [],
        ],
      );
    },
  );
}
