import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/store/AppState.dart';

import '../../api/epas/EPAS.dart';

Widget EPASAlertContainer() {
  return StoreConnector<AppState, ExtensionManager>(
    converter: (store) => store.state.extensionManager,
    builder: (context, extensionManager) {
      final EPASApi epasApi = extensionManager.getExtensions("EPAS");
      return AnimatedAlign(
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          heightFactor: epasApi.alert.isShow ? 1 : 0,
          child: Container(
              padding: EdgeInsets.all(20),
              color: Theme.of(context).scaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    epasApi.alert.isOk
                        ? Icons.check_circle
                        : Icons.do_not_disturb_on,
                    color: epasApi.alert.isOk ? Colors.green : Colors.red,
                  ),
                  Expanded(
                    child: Text(
                      epasApi.alert.info ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: epasApi.alert.isOk ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )));
    },
  );
}
