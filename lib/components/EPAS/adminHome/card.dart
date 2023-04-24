import 'package:flutter/material.dart';
import 'package:scv_app/components/EPAS/flatingCard.dart';
import 'package:scv_app/pages/EPAS/adminChechView.dart';
import 'package:scv_app/pages/EPAS/adminQRScaner.dart';

Widget EPASAdminHomeCard(BuildContext context) {
  int code;
  void setCode(int newCode) {
    code = newCode;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EPASAdminChechView(code)));
  }

  void goToQRScanner() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EPASAdminQRScanner(setCode)));
  }

  

  void showInput() {
    //create input dialog
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
          GestureDetector(
            child: Icon(Icons.qr_code_scanner_outlined, size: 100),
            onTap: goToQRScanner,
          ),
          TextButton(
              onPressed: showInput,
              child: Text(
                "Ročno vnesi kodo",
                style: TextStyle(decoration: TextDecoration.underline),
              )),
        ],
      ));
}
