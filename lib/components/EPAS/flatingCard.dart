import 'package:flutter/material.dart';

Widget FloatingCard(BuildContext context, {Widget? child, double padding = 40}) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]),
    width: MediaQuery.of(context).size.width - padding,
    child: child,
  );
}
