import 'package:flutter/material.dart';

class GlobalAlert {
  bool isShow = false;
  String text = '';
  Widget action;

  bool show(String text, Widget action) {
    if (isShow == true) {
      return false;
    }
    this.text = text;
    this.isShow = true;
    this.action = action;
    return true;
  }

  void hide() {
    this.isShow = false;
  }
}
