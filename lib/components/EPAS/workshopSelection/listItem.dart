import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/workshop.dart';

Widget EPASWorkshopSelectionListItem(EPASWorkshop workshop, {Function onTap}) {
  return GestureDetector(
      onTap: onTap,
  child: Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          workshop.name.toUpperCase(),
          style: TextStyle(fontSize: 19),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 22,
        )
      ]));
}
