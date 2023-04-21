import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/pages/EPAS/timetableSelection.dart';

import 'listItem.dart';

Widget EPASWorkshopSelectionList(
    List<EPASWorkshop> workshops, int timetableId, BuildContext context) {
  void goToTimetableSelection(int workshopId) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return EPASTimetableSelection(timetableId, workshopId);
    }));
  }

  return Expanded(
      child: ListView.separated(
    padding: EdgeInsets.only(top: 30, left: 20, right: 20),
    itemCount: workshops.length,
    separatorBuilder: (context, index) => SizedBox(
      height: 15,
    ),
    itemBuilder: (context, index) {
      return EPASWorkshopSelectionListItem(context, workshops[index],
          onTap: () {
        goToTimetableSelection(workshops[index].id);
      });
    },
  ));
}
