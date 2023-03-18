import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:uni_links/uni_links.dart';

bool initialURILinkHandled = false;
StreamSubscription universalLinkSubscription;
String universalLink = "";
var dummyDeepLinkedUrl;

Future<void> initURIHandler() async {
  if (!initialURILinkHandled) {
    initialURILinkHandled = true;
    try {
      final initialURI =
          await getInitialUri(); // Dobimo povezavo s katero je bila aplikacija zagnana
      if (initialURI != null && initialURI != dummyDeepLinkedUrl) {
        universalLink = initialURI.toString();
        print("Initial universal link: $universalLink");
        dummyDeepLinkedUrl = initialURI;
      }
    } catch (_) {}
    //delete initial uri
    universalLink = "";
  }
}

void incomingURIHandler() {
  try {
    universalLinkSubscription = uriLinkStream.listen((Uri uri) {
      universalLink = uri.toString();
      print("Universal link: $universalLink");
    }, onError: (Object err) {});
  } catch (e) {}
}

void goToUnlockPassDoor(BuildContext context, String uri,
    {bool close = false}) {
  universalLink = "";
  if (chechURI(uri) || close) {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    if (!close) {
      windowManager.showWindow("PassDoor", attributes: {"uri": uri});
    } else {
      windowManager.hideWindow("PassDoor");
    }

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
