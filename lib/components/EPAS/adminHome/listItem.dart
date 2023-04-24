import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

Widget EPASAdminHomeListItem(EPASWorkshop workshop) {
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              timetable?.getStartHour() ?? "",
              style: TextStyle(fontSize: 18),
            ),
            Text("${workshop.usersCount}/${workshop.maxUsers}",
                style: TextStyle(fontSize: 18, color: countColor))
          ],
        );
      });
}
