import 'package:flutter/material.dart';

import '../../extension/hexColor.dart';

BoxDecoration mealsBoxDecoration(BuildContext context,
    {bool isSelected = false}) {
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
    border: Border.all(
      color: isSelected ? Colors.green : Colors.transparent,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(15),
  );
}
