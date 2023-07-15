import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/adminWorkshopJoinList.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

Widget EPASAdminHomeListItem(BuildContext context, EPASWorkshop workshop,
    Function changeSelectedWorkshopId, int currentSelectedWorkshopId) {
  void showJoinList() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EPASAdminWorkshopJoinList(workshop.id)));
  }

  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;
        final EPASTimetable? timetable = epasApi.timetables.firstWhere(
            (timetable) => timetable.id == workshop.timetable_id);
        final Color countColor = workshop.usersCount >= workshop.maxUsers
            ? EPASStyle.fullPlaceColor
            : EPASStyle.freePlaceColor;
        final TextDecoration textDecoration =
            workshop.id == currentSelectedWorkshopId
                ? TextDecoration.underline
                : TextDecoration.none;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                child: Text(
                  timetable?.getStartHour() ?? "",
                  style: TextStyle(fontSize: 18, decoration: textDecoration),
                ),
                onTap: () => changeSelectedWorkshopId(workshop.id)),
            GestureDetector(
              child: Text("${workshop.usersCount}/${workshop.maxUsers}",
                  style: TextStyle(
                      fontSize: 18,
                      color: countColor,
                      decoration: textDecoration)),
              onTap: showJoinList,
            )
          ],
        );
      });
}
