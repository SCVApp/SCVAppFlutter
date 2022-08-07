import 'package:flutter/material.dart';

Widget backButton(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(padding: EdgeInsets.fromLTRB(20, 20, 0, 0)),
      CircleAvatar(
        backgroundColor: Colors.transparent,
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => {Navigator.of(context).pop()}),
      ),
    ],
  );
}
