import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/store/AppState.dart';

Widget EPASAdminHomeTitle(
    BuildContext context, void Function() goBack, int currentSelectedWorkshopId) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi =
            extensionManager.getExtensions("EPAS") as EPASApi;
        final EPASWorkshop? workshop = epasApi.workshops
            .firstWhere((element) => element.id == currentSelectedWorkshopId);
        final EPASTimetable? timetable = epasApi.timetables
            .firstWhere((element) => element.id == workshop?.timetable_id);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButton(
              onPressed: goBack,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "VODJA",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Delavnica: ${workshop?.name ?? ""}, ${timetable?.getStartHour() ?? ""}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    )
                  ])
            ]),
          ],
        );
      });
}
