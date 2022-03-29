import 'package:babstrap_settings_screen/src/babs_component_settings_item.dart';
import 'package:babstrap_settings_screen/src/settings_screen_utils.dart';
import 'package:flutter/material.dart';

/// This component group the Settings items (BabsComponentSettingsItem)
/// All one BabsComponentSettingsGroup have a title and the developper can improve the design.
class NastavitveGroup extends StatelessWidget {
  String settingsGroupTitle;
  TextStyle settingsGroupTitleStyle;
  List<SettingsItem> items;
  // Icons size
  double iconItemSize;

  NastavitveGroup(
      {this.settingsGroupTitle,
      this.settingsGroupTitleStyle,
      this.items,
      this.iconItemSize = 25});

  @override
  Widget build(BuildContext context) {
    if (this.iconItemSize != null)
      SettingsScreenUtils.settingsGroupIconSize = iconItemSize;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      constraints: BoxConstraints(maxHeight: double.infinity,maxWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The title
          (settingsGroupTitle != null)
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    settingsGroupTitle,
                    style: (settingsGroupTitleStyle == null)
                        ? TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                        : settingsGroupTitleStyle,
                  ),
                )
              : Container(),
          // The SettingsGroup sections
          Container(
            child: ListView.separated(
              physics: ScrollPhysics(),
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              },
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
