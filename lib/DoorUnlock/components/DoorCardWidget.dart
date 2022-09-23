import 'package:flutter/material.dart';

Widget DoorCardWidget(BuildContext context, Color color, Widget child,
    {double padding_inside = 40}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 40),
    child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(padding_inside),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 5,
              offset: Offset(0, 8), // Shadow position
            ),
          ],
        ),
        child: child),
  );
}
