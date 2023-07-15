import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/components/EPAS/halfScreenCard.dart';
import 'package:scv_app/components/EPAS/timetableSelection/button.dart';
import 'package:scv_app/components/EPAS/timetableSelection/listItem.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

import '../../../api/epas/EPAS.dart';
import '../../../manager/extensionManager.dart';

Widget EPASTimetableSelectionList(
    BuildContext context, int currentSelectedTimetableId, int currentSelectedWorkshopId,
    {Function? changeSelectedTimetableId, void Function()?  joinWorkshop}) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;
        return HalfScreenCard(context,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 70)),
                Text(
                  "Zasedena mesta:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Expanded(
                    child: ListView(
                        children: [
                  if (epasApi.workshops.length == epasApi.timetables.length)
                    for (EPASWorkshop workshop in epasApi.workshops)
                      EPASTimetableSelectionListItem(
                          context, workshop, currentSelectedTimetableId,
                          changeSelectedTimetableId: changeSelectedTimetableId),
                  if (epasApi.workshops.length != epasApi.timetables.length)
                    loadingItem(EPASStyle.backgroundColor),
                ].withSpaceBetween(spacing: 20))),
                EPASTimetableSelectionButton(
                    context, currentSelectedTimetableId, currentSelectedWorkshopId,
                    onTap: joinWorkshop)
              ],
            ),
            rightPadding: 25);
      });
}
