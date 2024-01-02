import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/api/appTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget ThemesSelector(
    BuildContext context, AppThemeType appThemeType, Function handleThemeChange,
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
          (AppLocalizations.of(context)!.available_themes),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Padding(padding: EdgeInsets.only(bottom: 20)),
        ThemeSelector(appThemeType, handleThemeChange,
            theme: AppThemeType.Light, ime: (AppLocalizations.of(context)!.light_theme)),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        ThemeSelector(appThemeType, handleThemeChange,
            theme: AppThemeType.Dark, ime: (AppLocalizations.of(context)!.dark_theme)),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        ThemeSelector(appThemeType, handleThemeChange,
            theme: AppThemeType.System, ime: (AppLocalizations.of(context)!.system_theme)),
      ],
    ),
    padding: EdgeInsets.only(
        top: innerPadding, bottom: 60, left: innerPadding, right: innerPadding),
  );
}

Widget ThemeSelector(AppThemeType appThemeType, Function handleThemeChange,
    {AppThemeType theme = AppThemeType.System, String ime = "Sistemsko"}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        ime,
        style: TextStyle(fontSize: 16),
      ),
      CupertinoSwitch(
        value: appThemeType == theme,
        onChanged: (value) {
          handleThemeChange(theme);
        },
      ),
    ],
  );
}
