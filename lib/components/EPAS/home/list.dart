import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/EPAS/home/listItem.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';

import '../../../api/epas/EPAS.dart';
import '../../../extension/hexColor.dart';
import '../../../store/AppState.dart';

Widget EPASHomeList(BuildContext context) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");
        return Container(
            padding: EdgeInsets.only(left: 25, right: 10),
            width: MediaQuery.of(context).size.width,
            height: max(MediaQuery.of(context).size.height * 0.6, 300),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 70)),
                for (int i = 0; i < epasApi.timetables.length; i++)
                  EPASHomeListItem(i + 1, "Ni določeno"),
                if (epasApi.loading) loadingItem(EPASStyle.backgroundColor),
                if (!epasApi.loading && epasApi.timetables.length == 0)
                  Text(
                    "Ni podatkov",
                  ),
              ].withSpaceBetween(spacing: 20),
            ));
      });
}
