import 'package:flutter/material.dart';

Widget DoorCardWidget(BuildContext context, Color color, Widget child,
    {double padding = 40}) {
  return Padding(
    padding: EdgeInsets.only(left: padding, right: padding, bottom: 20),
    child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(padding),
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
