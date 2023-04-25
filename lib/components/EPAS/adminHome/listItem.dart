import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

Widget EPASAdminHomeListItem(EPASWorkshop workshop,
    Function changeSelectedWorkshopId, int currentSelectedWorkshopId) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");
        final EPASTimetable timetable = epasApi.timetables.firstWhere(
            (timetable) => timetable.id == workshop.timetable_id,
            orElse: () => null);
        final Color countColor = workshop.usersCount >= workshop.maxUsers
            ? EPASStyle.fullPlaceColor
            : EPASStyle.freePlaceColor;
        final TextDecoration textDecoration =
            workshop.id == currentSelectedWorkshopId
                ? TextDecoration.underline
                : TextDecoration.none;
        return GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timetable?.getStartHour() ?? "",
                style: TextStyle(fontSize: 18, decoration: textDecoration),
              ),
              Text("${workshop.usersCount}/${workshop.maxUsers}",
                  style: TextStyle(
                      fontSize: 18,
                      color: countColor,
                      decoration: textDecoration))
            ],
          ),
          onTap: () {
            changeSelectedWorkshopId(workshop.id);
          },
        );
      });
}
