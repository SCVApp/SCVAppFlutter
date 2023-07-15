import 'dart:math';

import 'package:flutter/material.dart';

Widget HalfScreenCard(BuildContext context,
    {Widget? child, double leftPadding = 25, double rightPadding = 10}) {
  return Container(
    padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
    width: MediaQuery.of(context).size.width,
    height: max(MediaQuery.of(context).size.height * 0.65, 300),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    child: child,
    clipBehavior: Clip.none,
  );
}
