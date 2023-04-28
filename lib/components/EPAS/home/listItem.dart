import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/extension/hexColor.dart';

Widget EPASHomeListItem(
    int number, EPASTimetable timetable, List<EPASWorkshop> joinedWorkshops,
    {Function onTap}) {
  final EPASWorkshop workshop = joinedWorkshops.firstWhere(
      (workshop) => workshop.id == timetable.selected_workshop_id,
      orElse: () => null);
  return GestureDetector(
      onTap: onTap,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(children: [
              Text("DELAVNICA "),
              Text(number.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  workshop != null
                      ? "${workshop?.name} - ${timetable.getStartHour()}"
                      : "Ni izbrana",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: HexColor.fromHex("#838383")),
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Icon(
                  workshop?.attended != true
                      ? Icons.arrow_forward_ios
                      : Icons.check,
                  size: 25,
                )
              ],
            ),
          ]));
}
