import 'package:flutter/services.dart';
import 'package:scv_app/components/confirmAlert.dart';
import 'package:scv_app/global/global.dart' as global;

class WatchManager {
  final channel = const MethodChannel("com.SCVApp.si");

  void sendMessagesToWatch(String method, Map<String, dynamic> data) {
    print("Sending message to watch: " + method);
    this
        .channel
        .invokeMethod("forwardToAppleWatch", {"method": method, "data": data});
  }

  void listenForMessagesFromWatch() {
    this.channel.setMethodCallHandler((call) async {
      try {
        final methodName = call.method;
        final arguments = Map<String, dynamic>.from(call.arguments);
        this.handelMessagesFromWatch(methodName, arguments);
      } catch (e) {
        print(e);
      }
    });
  }

  void handelMessagesFromWatch(
      String methodName, Map<String, dynamic> arguments) {
    switch (methodName) {
      case "requestLoginFromWatch":
        this.handelLoginFromWatch(arguments);
        break;
    }
  }

  void handelLoginFromWatch(Map<String, dynamic> arguments) {
    if (global.token.accessToken == null) return;
    final String login = arguments["login"];
    if (login == "login") {
      confirmAlert(global.globalBuildContext, "Ali se ležiš prijaviti v uro?",
          loginInToWatch, () => {});
    }
  }

  void loginInToWatch() {
    this.sendMessagesToWatch("loginFromPhone", {
      "accessToken": global.token.accessToken,
      "refreshToken": global.token.refreshToken,
      "expiresOn": global.token.expiresOn
    });
  }
}
