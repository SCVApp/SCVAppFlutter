import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/extension/hexColor.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

import '../../../manager/extensionManager.dart';

Widget EPASWorkshopSelectionListItem(
    BuildContext context, EPASWorkshop workshop,
    {void Function()? onTap}) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;
        bool isUserJoinedInWorkshopWithName = false;
        for (EPASTimetable timetable in epasApi.timetables) {
          EPASWorkshop? selectedWorkShop = epasApi.joinedWorkshops.firstWhere(
              (workshop) => workshop.id == timetable.selected_workshop_id);
          if (selectedWorkShop != null &&
              selectedWorkShop.name == workshop.name) {
            isUserJoinedInWorkshopWithName = true;
            break;
          }
        }
        final Color itemColor = isUserJoinedInWorkshopWithName
            ? EPASStyle.backgroundColor
            : workshop.usersCount >= workshop.maxUsers
                ? HexColor.fromHex('#A7A7A7')
                : Theme.of(context).primaryColor;
        return GestureDetector(
            onTap: onTap,
            child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    workshop.name.toUpperCase(),
                    style: TextStyle(fontSize: 19, color: itemColor),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 22,
                    color: itemColor,
                  )
                ]));
      });
}
