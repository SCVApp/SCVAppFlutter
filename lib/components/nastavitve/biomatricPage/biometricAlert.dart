import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/global/global.dart' as global;

Future<void> biometricAlert(BuildContext context,
    {List<Widget> actions}) async {
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
            children: const <Widget>[
              Text(
                  'V telefonu nimaš nastavljenih varnostnih nastavitev. Zato vam nemoremo odkleniti aplikacije.'),
            ],
          ),
        ),
        actions: <Widget>[
          ...actions,
          TextButton(
              child: const Text('Odpri nastavitve',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () => pojdiVNastavitve()),
        ],
      );
    },
  );
}
