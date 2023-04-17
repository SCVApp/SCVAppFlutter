import 'dart:math';

import 'package:flutter/material.dart';

Widget HalfScreenCard(BuildContext context, {Widget child}){
  return Container(
            padding: EdgeInsets.only(left: 25, right: 10),
            width: MediaQuery.of(context).size.width,
            height: max(MediaQuery.of(context).size.height * 0.6, 300),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: child,);
}