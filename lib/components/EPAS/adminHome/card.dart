import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scv_app/components/EPAS/flatingCard.dart';
import 'package:scv_app/pages/EPAS/style.dart';

Widget EPASAdminHomeCard(
    BuildContext context, int currentSelectedWorkshopId, Function setCode) {
  int code;

  void showInput() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Vnesi kodo"),
            content: TextField(
              cursorColor: EPASStyle.backgroundColor,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: "Koda uporabnika",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: EPASStyle.backgroundColor),
                ),
              ),
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
                  child: Text(
                    "Prekliči",
                    style: TextStyle(color: EPASStyle.backgroundColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setCode(code);
                  },
                  child: Text("Potrdi",
                      style: TextStyle(color: EPASStyle.backgroundColor))),
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
