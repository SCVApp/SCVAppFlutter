import 'package:flutter/material.dart';
import 'package:scv_app/extension/hexColor.dart';

Widget EPASHomeListItem(int number, String text) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(children: [
          Text("DELAVNICA "),
          Text(number.toString(), style: TextStyle(fontWeight: FontWeight.bold))
        ]),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(color: HexColor.fromHex("#838383")),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Icon(
              Icons.arrow_forward_ios,
              size: 25,
            )
          ],
        ),
      ]);
}
