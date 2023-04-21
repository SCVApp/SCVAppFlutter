import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/pages/EPAS/style.dart';

Widget EPASTimetableSelectionListItem(
    BuildContext context,
    EPASWorkshop workshop,
    List<EPASTimetable> timetables,
    int currentSelectedTimetableId,
    {Function changeSelectedTimetableId}) {
  final EPASTimetable timetable = timetables.firstWhere(
      (timetable) => timetable.id == workshop.timetable_id,
      orElse: () => null);
  final TextDecoration decoration = timetable.id == currentSelectedTimetableId
      ? TextDecoration.underline
      : TextDecoration.none;
  return GestureDetector(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          timetable?.getStartHour() ?? "--.--",
          style: TextStyle(fontSize: 18, decoration: decoration),
        ),
        Text(
          "${workshop.usersCount}/${workshop.maxUsers}",
          style: TextStyle(
              fontSize: 18,
              decoration: decoration,
              color: workshop.usersCount >= workshop.maxUsers
                  ? EPASStyle.fullPlaceColor
                  : EPASStyle.freePlaceColor),
        )
      ],
    ),
    onTap: () {
      changeSelectedTimetableId(timetable.id, workshop.id);
    },
  );
}
