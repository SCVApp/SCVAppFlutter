import 'package:firebase_analytics/firebase_analytics.dart';

class EventTracking {
  static Future<void> trackScreenView(
      String screenName, String className) async {
    await FirebaseAnalytics.instance.logEvent(name: "screen_view", parameters: {
      "screen_name": screenName,
      "screen_class": className,
    });
  }

  static Future<void> setUserProperties(String name, String value) async {
    await FirebaseAnalytics.instance.setUserProperty(name: name, value: value);
  }

  static Future<void> loginEvent(String schoolID, String classID) async {
    await FirebaseAnalytics.instance.logLogin();
    await setUserProperties("schoolID", schoolID);
    await setUserProperties("classID", classID);
  }
}
