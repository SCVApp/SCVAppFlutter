import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/store/AppState.dart';

import '../../../api/epas/EPAS.dart';
import '../../../manager/extensionManager.dart';
import '../../../pages/EPAS/style.dart';

Widget EPASTimetableSelectionButton(BuildContext context,
    int currentSelectedTimetableId, int currentSelectedWorkshopId,
    {Function onTap}) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");
        final EPASTimetable currentSelectedTimetable = epasApi.timetables
            .firstWhere(
                (timetable) => timetable.id == currentSelectedTimetableId,
                orElse: () => null);
        final EPASWorkshop currentSelectedWorkshop = epasApi.workshops
            .firstWhere((workshop) => workshop.id == currentSelectedWorkshopId,
                orElse: () => null);
        String textForButton =
            "PRIJAVI SE NA DELAVNICO (${currentSelectedTimetable?.getStartHour() ?? "--.--"})";
        Color colorForButton = EPASStyle.backgroundColor;
        if (currentSelectedTimetable.selected_workshop_id ==
            currentSelectedWorkshopId) {
          textForButton = "NA TO DELAVNICO SI ŽE PRIJAVLJEN/NA";
          colorForButton = EPASStyle.alreadyJoinedColor;
        } else if (currentSelectedWorkshop.usersCount >=
            currentSelectedWorkshop.maxUsers) {
          textForButton = "DELAVNICA JE POLNA";
          colorForButton = EPASStyle.fullPlaceColor;
        }
        return Padding(
          child: Container(
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: colorForButton,
                ),
                child: Padding(
                  child: Text(
                    textForButton,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                onPressed: onTap,
              )),
          padding: EdgeInsets.only(bottom: 30),
        );
      });
}
