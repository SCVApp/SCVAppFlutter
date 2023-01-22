import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:uni_links/uni_links.dart';

bool initialURILinkHandled = false;
StreamSubscription universalLinkSubscription;

Future<void> initURIHandler(BuildContext context) async {
  if (!initialURILinkHandled) {
    initialURILinkHandled = true;
    try {
      final initialURI = await getInitialUri();
      if (initialURI != null) {
        goToUnlockPassDoor(context, initialURI.toString());
      }
    } catch (_) {}
  }
}

void incomingURIHandler(BuildContext context) {
  try {
    universalLinkSubscription = uriLinkStream.listen((Uri uri) {
      goToUnlockPassDoor(context, uri.toString());
    }, onError: (Object err) {});
  } catch (e) {}
}

void goToUnlockPassDoor(BuildContext context, String uri) {
  print(uri);
  if (chechURI(uri)) {
    print(uri);
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;

    windowManager.showWindow("PassDoor");

    StoreProvider.of<AppState>(context).dispatch(windowManager);
  }
}

bool chechURI(String uri) {
  if (uri == null) return false;
  if (uri.startsWith("scvapp://app.scv.si/open_door/")) {
    return true;
  }
  return false;
}
