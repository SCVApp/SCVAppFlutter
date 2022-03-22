import 'package:babstrap_settings_screen/src/icon_style.dart';
import 'package:babstrap_settings_screen/src/settings_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

class NastavitveItem extends SettingsItem {
  IconData icons;
  IconStyle iconStyle;
  String title;
  TextStyle titleStyle;
  String subtitle;
  TextStyle subtitleStyle;
  Widget trailing;
  VoidCallback onTap;

  NastavitveItem({
      this.icons,
      this.iconStyle,
      this.title,
      this.titleStyle,
      this.subtitle = "",
      this.subtitleStyle,
      this.trailing,
      this.onTap
      });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      style: ListTileStyle.drawer,
      leading: (iconStyle != null && iconStyle.withBackground)
          ? Container(
              decoration: BoxDecoration(
                color: iconStyle.backgroundColor,
                borderRadius: BorderRadius.circular(iconStyle.borderRadius),
              ),
              padding: EdgeInsets.all(5),
              child: Icon(
                icons,
                size: SettingsScreenUtils.settingsGroupIconSize,
                color: iconStyle.iconsColor,
              ),
            )
          : Icon(
              icons,
              size: SettingsScreenUtils.settingsGroupIconSize,
            ),
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
          (trailing != null) ? trailing : Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
