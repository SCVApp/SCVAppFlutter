import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/global/global.dart' as global;

import '../api/extension.dart';
import '../store/AppState.dart';

class ExtensionManager {
  bool initialised = false;
  List<Extension> extensions = [new EPASApi()];

  Extension getExtensions(String name) {
    return extensions
        .firstWhere((Extension extension) => extension.name == name);
  }

  bool getExtensionEnabled(String name) {
    return extensions
            .firstWhere((Extension extension) => extension.name == name)
            .enabled ??
        false;
  }

  bool getExtensionAuthorised(String name) {
    return extensions
            .firstWhere((Extension extension) => extension.name == name)
            .authorised ??
        false;
  }

  Future<void> checkAuth() async {
    final promises = <Future>[];
    for (Extension extension in extensions) {
      if (extension.enabled) {
        promises.add(extension.checkAuth());
      }
    }
    await Future.wait(promises);
  }

  static Future<void> loadExtenstions(BuildContext context) async {
    if (global.token?.accessToken == null) return;
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    if (extensionManager.initialised) return;
    await extensionManager.checkAuth();
    extensionManager.initialised = true;
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }
}
