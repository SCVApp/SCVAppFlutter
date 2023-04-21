import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

import '../../../api/epas/EPAS.dart';

Widget EPASTimetableSelectionListItem(
    BuildContext context, EPASWorkshop workshop, int currentSelectedTimetableId,
    {Function changeSelectedTimetableId}) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");
        final EPASTimetable timetable = epasApi.timetables.firstWhere(
            (timetable) => timetable.id == workshop.timetable_id,
            orElse: () => null);
        final bool alreadyJoined = epasApi.joinedWorkshops.firstWhere(
                (joinedWorkshop) => joinedWorkshop.id == workshop.id,
                orElse: () => null) !=
            null;
        final TextDecoration decoration =
            timetable.id == currentSelectedTimetableId
                ? TextDecoration.underline
                : TextDecoration.none;
        return GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timetable?.getStartHour() ?? "--.--",
                style: TextStyle(
                    fontSize: 18,
                    decoration: decoration,
                    color: alreadyJoined
                        ? EPASStyle.backgroundColor
                        : Theme.of(context).primaryColor),
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
      });
}
