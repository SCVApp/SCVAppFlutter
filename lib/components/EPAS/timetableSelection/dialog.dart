import 'package:flutter/material.dart';

AlertDialog EPASTimetableSelectionDialog(String title, String content,
    {List<Widget>? actions}) {
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: actions,
  );
}
