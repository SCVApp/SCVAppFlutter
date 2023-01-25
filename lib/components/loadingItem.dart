import 'package:flutter/material.dart';

Widget loadingItem(Color color) {
  return Container(
    height: 50,
    child: Center(
      child: CircularProgressIndicator(color: color,),
    ),
  );
}
