import 'package:flutter/material.dart';
import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/api/urnik/ura.dart';
import 'package:scv_app/components/urnik/viewForUra.dart';
import 'package:scv_app/pages/Urnik/style.dart';

Widget viewForUre(ObdobjaUr obdobjeUr, Function(int) callback,
    ViewSizes viewSizes, BuildContext context) {
  return PageView(
    clipBehavior: Clip.none,
    onPageChanged: callback,
    children: [
      for (Ura ura in obdobjeUr.ure)
        Padding(
            child: viewForUra(obdobjeUr, ura, viewSizes, context),
            padding: EdgeInsets.symmetric(horizontal: 25)),
    ],
  );
}
