import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/timetable.dart';

import '../../../pages/EPAS/style.dart';

Widget EPASTimetableSelectionButton(BuildContext context,
    int currentSelectedTimetableId, List<EPASTimetable> timetables, {Function onTap}) {
  final EPASTimetable currentSelectedTimetable = timetables.firstWhere(
      (timetable) => timetable.id == currentSelectedTimetableId,
      orElse: () => null);
  return Padding(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: EPASStyle.backgroundColor,
          ),
          child: Padding(
            child: Text(
              "PRIJAVI SE NA DELAVNICO (${currentSelectedTimetable?.getStartHour() ?? "--.--"})",
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
          onPressed: onTap,
        )
      ],
    ),
    padding: EdgeInsets.only(bottom: 30),
  );
}
