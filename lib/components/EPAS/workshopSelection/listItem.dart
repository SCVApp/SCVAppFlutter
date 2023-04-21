import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/extension/hexColor.dart';

Widget EPASWorkshopSelectionListItem(
    BuildContext context, EPASWorkshop workshop,
    {Function onTap}) {
  final Color itemColor = workshop.usersCount >= workshop.maxUsers
      ? HexColor.fromHex('#A7A7A7')
      : Theme.of(context).primaryColor;
  return GestureDetector(
      onTap: onTap,
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              workshop.name.toUpperCase(),
              style: TextStyle(fontSize: 19, color: itemColor),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 22,
              color: itemColor,
            )
          ]));
}
