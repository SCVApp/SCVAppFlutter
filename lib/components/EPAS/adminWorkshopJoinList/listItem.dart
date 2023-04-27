import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/EPASUserListItem.dart';

Widget EPASAdminWorkshopJoinListItem(EPASUserListItem user) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(user.displayName),
    Icon(user.attended == true ? Icons.check : Icons.close,
        color: user.attended == true ? Colors.green : Colors.red),
  ]);
}
