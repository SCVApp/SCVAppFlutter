import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/components/EPAS/flatingCard.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/store/AppState.dart';

Widget EPASHomeCard(BuildContext context) {
  return StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");

        return FloatingCard(
          context,
          child: Column(
            children: <Widget>[
              QrImage(
                data: epasApi.userCode.toString(),
                size: 170,
                foregroundColor: Theme.of(context).primaryColor,
                embeddedImage: AssetImage("assets/images/1024.png"),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Wrap(
                children: [
                  Text("KODA: "),
                  Text(
                    epasApi.userCode.toString().substring(0, 3) +
                        " " +
                        epasApi.userCode.toString().substring(3, 6),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        );
      });
}
