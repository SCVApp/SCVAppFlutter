import 'package:flutter/material.dart';

import '../../extension/hexColor.dart';

BoxDecoration mealsBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).cardColor,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).shadowColor,
        spreadRadius: 1,
        blurRadius: 1,
        offset: Offset(0, 2), // changes position of shadow
      ),
    ],
    borderRadius: BorderRadius.circular(15),
  );
}