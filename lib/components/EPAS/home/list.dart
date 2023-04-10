import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scv_app/components/EPAS/home/listItem.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';

Widget EPASHomeList(BuildContext context) {
  return Container(
      padding: EdgeInsets.only(left: 25, right: 10),
      width: MediaQuery.of(context).size.width,
      height: max(MediaQuery.of(context).size.height * 0.6, 300),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 70)),
          EPASHomeListItem(1, "Ni določeno"),
          EPASHomeListItem(2, "Luksemburg - 10.30"),
          EPASHomeListItem(3, "Ni določeno"),
          EPASHomeListItem(4, "Ni določeno"),
        ].withSpaceBetween(spacing: 20),
      ));
}
