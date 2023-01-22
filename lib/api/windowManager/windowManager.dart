import 'package:scv_app/api/windowManager/window.dart';

class WindowManager {
  List<Window> windows = [];

  WindowManager() {
    windows.add(new Window(name: "PassDoor", pageViewIndex: 2));
  }

  bool haveToChangeWindow(int currentIndex) {
    for (var window in windows) {
      if (window.isShown == true && window.pageViewIndex == currentIndex) {
        return false;
      } else if (window.isShown == true &&
          window.pageViewIndex != currentIndex) {
        return true;
      }
    }
    return false;
  }

  int getIndexOfWindow() {
    for (var window in windows) {
      if (window.isShown == true) {
        return window.pageViewIndex;
      }
    }
    return 0;
  }

  void showWindow(String name, {Map<String, dynamic> attributes = const {}}) {
    for (var window in windows) {
      if (window.name == name) {
        window.attributes = attributes;
        window.isShown = true;
      } else {
        window.isShown = false;
      }
    }
  }

  void hideWindow(String name) {
    for (var window in windows) {
      if (window.name == name) {
        window.isShown = false;
      }
    }
  }
}
