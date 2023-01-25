import 'package:flutter/material.dart';

import '../../../extension/hexColor.dart';

Widget unlockButton(BuildContext context, Function onStartUp) {
  double widget = MediaQuery.of(context).size.width * 0.3;
  double height = widget * 0.36;
  double textSize = height * 0.37;
  return LayoutBuilder(builder: ((context, constraints) {
    return TextButton(
        child: Container(
          decoration: BoxDecoration(
            color: HexColor.fromHex("#16A7D4"),
            borderRadius: BorderRadius.circular(7),
          ),
          width: widget,
          height: height,
          child: Center(
              child: Text(
            "Avtorizacija",
            style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: textSize),
          )),
        ),
        onPressed: () {
          onStartUp();
        });
  }));
}
