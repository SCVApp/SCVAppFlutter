import 'package:flutter/material.dart';

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
              Text(text ?? ''),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(child: const Text('Yes'), onPressed: yesFunction),
          TextButton(child: const Text('No'), onPressed: noFunction),
        ],
      );
    },
  );
}
