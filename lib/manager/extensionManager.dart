import 'package:scv_app/api/epas/EPAS.dart';

import '../api/extension.dart';

class ExtensionManager {
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

  void checkAuth() {
    for (Extension extension in extensions) {
      if (extension.enabled) extension.checkAuth();
    }
  }
}
