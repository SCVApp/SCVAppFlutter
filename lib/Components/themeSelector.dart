import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/theme.dart';

Widget ThemesSelector(
    BuildContext context, ThemeEnum themeEnum, Function handleThemeChange,
    {double padding = 50, double innerPadding = 25}) {
  return Container(
    width: MediaQuery.of(context).size.width - padding,
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Teme, ki so na voljo:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Padding(padding: EdgeInsets.only(bottom: 20)),
        ThemeSelector(themeEnum, handleThemeChange,
            theme: ThemeEnum.light, ime: "Svetla"),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        ThemeSelector(themeEnum, handleThemeChange,
            theme: ThemeEnum.dark, ime: "Temna"),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        ThemeSelector(themeEnum, handleThemeChange,
            theme: ThemeEnum.system, ime: "Sistemsko"),
      ],
    ),
    padding: EdgeInsets.only(
        top: innerPadding, bottom: 60, left: innerPadding, right: innerPadding),
  );
}

Widget ThemeSelector(ThemeEnum themeEnum, Function handleThemeChange,
    {ThemeEnum theme = ThemeEnum.system, String ime = "Sistemsko"}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        ime,
        style: TextStyle(fontSize: 16),
      ),
      CupertinoSwitch(
        value: themeEnum == theme,
        onChanged: (value) {
          handleThemeChange(theme);
        },
      ),
    ],
  );
}
