import 'package:babstrap_settings_screen/src/icon_style.dart';
import 'package:babstrap_settings_screen/src/settings_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:scv_app/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusItem extends SettingsItem {
  ImageProvider imageProvider;
  String title;
  String statusId;
  TextStyle titleStyle;
  String subtitle;
  TextStyle subtitleStyle;
  Widget trailing;
  SharedPreferences prefs;
  VoidCallback onTap;

  StatusItem(
      {this.imageProvider,
      this.title,
      this.titleStyle,
      this.subtitle = "",
      this.subtitleStyle,
      this.trailing,
      this.statusId,
      this.prefs});


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image(image: imageProvider,width: 30,),
      title: Text(
        title,
        style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
      subtitle: Text(
        subtitle,
        style: subtitleStyle ?? TextStyle(color: Colors.grey),
        maxLines: 1,
      ),
      trailing:
          (trailing != null) ? trailing : null,
    );
  }
}
