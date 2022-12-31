import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/user.dart';

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
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user,
        builder: (context, user) {
          return ListTile(
              onTap: onTap,
              leading: Image(
                image: imageProvider,
                width: 30,
              ),
              title: Text(
                title,
                style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              trailing: user.status.id == statusId
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )
                  : null);
        });
  }
}
