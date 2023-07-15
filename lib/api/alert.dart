import 'package:flutter/material.dart';

class GlobalAlert {
  bool isShow = false;
  String text = '';
  Widget? action;
  IconData? icon;

  bool show(String text, Widget? action, IconData? icon) {
    if (isShow == true) {
      return false;
    }
    this.text = text;
    this.isShow = true;
    this.action = action;
    this.icon = icon;
    return true;
  }

  void hide() {
    this.isShow = false;
  }
}
