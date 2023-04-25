import 'package:flutter/material.dart';
import 'package:scv_app/components/EPAS/flatingCard.dart';

Widget EPASAdminHomeCard(BuildContext context, int currentSelectedWorkshopId, Function setCode) {
  int code;

  void showInput() {
    print("showInput");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Vnesi kodo"),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                try {
                  code = int.parse(value);
                } catch (e) {
                  code = null;
                }
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Prekliči")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setCode(code);
                  },
                  child: Text("Potrdi")),
            ],
          );
        });
  }

  return FloatingCard(context,
      child: Column(
        children: [
          TextButton(
              onPressed: showInput,
              child: Text(
                "Ročno vnesi kodo",
                style: TextStyle(decoration: TextDecoration.underline),
              )),
        ],
      ));
}
