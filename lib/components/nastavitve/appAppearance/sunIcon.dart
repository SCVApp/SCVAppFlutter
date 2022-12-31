import 'package:flutter/material.dart';

import '../../../extension/hexColor.dart';

Widget SunIcon({double size = 50.0}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        color: HexColor.fromHex("EDA10F"), shape: BoxShape.circle),
  );
}
