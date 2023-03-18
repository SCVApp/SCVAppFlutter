import 'package:flutter/material.dart';

import '../../extension/hexColor.dart';

BoxDecoration mealsBoxDecoration() {
  return BoxDecoration(
    color: HexColor.fromHex("FAFAFA"),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.7),
        spreadRadius: 1,
        blurRadius: 1,
        offset: Offset(0, 2), // changes position of shadow
      ),
    ],
    borderRadius: BorderRadius.circular(15),
  );
}
