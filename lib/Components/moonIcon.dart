import 'package:flutter/material.dart';
import 'package:scv_app/Data/data.dart';

Widget MoonIcon(Color backgroundColor, {double size = 50.0}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: Stack(
      children: [
        Container(
          width: size - 25,
          height: size - 25,
          decoration:
              BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        )
      ],
    ),
  );
}
