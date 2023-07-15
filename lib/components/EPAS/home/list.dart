import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/components/EPAS/halfScreenCard.dart';
import 'package:scv_app/components/EPAS/home/card.dart';
import 'package:scv_app/components/EPAS/home/listItem.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';

import '../../../api/epas/EPAS.dart';
import '../../../pages/EPAS/workshopSelection.dart';
import '../../../store/AppState.dart';

Widget EPASHomeList(BuildContext context) {
  void goToSelectWorkshop(int timetableId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EPASWorkshopSelection(timetableId)));
  }

  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;
        return HalfScreenCard(context,
            child: Stack(clipBehavior: Clip.none, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 120)),
                  for (int i = 0; i < epasApi.timetables.length; i++)
                    EPASHomeListItem(
                        i + 1, epasApi.timetables[i], epasApi.joinedWorkshops,
                        onTap: () {
                      goToSelectWorkshop(epasApi.timetables[i].id);
                    }),
                  if (epasApi.loading) loadingItem(EPASStyle.backgroundColor),
                  if (!epasApi.loading && epasApi.timetables.length == 0)
                    Text(
                      "Ni podatkov",
                    ),
                ].withSpaceBetween(spacing: 20),
              ),
              Positioned(
                child: EPASHomeCard(context),
                top: -150,
              ),
            ]));
      });
}
