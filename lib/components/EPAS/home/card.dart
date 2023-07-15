import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/components/EPAS/flatingCard.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/store/AppState.dart';

Widget EPASHomeCard(BuildContext context) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;

        return FloatingCard(
          context,
          child: Column(
            children: <Widget>[
              // QrImage(
              //   data: "scvapp://app.scv.si/epas/code/${epasApi.userCode}",
              //   size: 170,
              //   foregroundColor: Theme.of(context).primaryColor,
              // ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Wrap(
                children: [
                  Text("KODA: "),
                  Text(
                    epasApi.userCode.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        );
      });
}
