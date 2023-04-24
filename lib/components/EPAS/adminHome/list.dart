import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/components/EPAS/adminHome/listItem.dart';
import 'package:scv_app/components/EPAS/halfScreenCard.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/store/AppState.dart';

Widget EPASAdminHomeList(BuildContext context) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");

        return HalfScreenCard(context,
            rightPadding: 25,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100)),
                    Text(
                      "Zasedena mesta:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                EPASAdminHomeListItem(epasApi.workshops[index]),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 15),
                            itemCount: epasApi.workshops.length))
                  ],
                )
              ],
            ));
      });
}
