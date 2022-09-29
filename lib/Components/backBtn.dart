import 'package:flutter/material.dart';

Widget backButton(BuildContext context,
    {IconData icon = Icons.arrow_back_ios}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(padding: EdgeInsets.fromLTRB(20, 20, 0, 0)),
      CircleAvatar(
        backgroundColor: Colors.transparent,
        child: IconButton(
            icon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => {Navigator.of(context).pop()}),
      ),
    ],
  );
}
