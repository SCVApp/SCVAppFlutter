import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> biometricAlert(BuildContext context,
    {List<Widget>? actions, String? text}) async {
  void pojdiVNastavitve() {
    Navigator.pop(context);
    AppSettings.openAppSettings();
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
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.pop(context)),
          TextButton(
              child: Text(AppLocalizations.of(context)!.open_settings,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: pojdiVNastavitve),
          ...actions ?? [],
        ],
      );
    },
  );
}
