import 'package:babstrap_settings_screen/src/settings_screen_utils.dart';
import 'package:flutter/material.dart';

class NastavitveGroup extends StatelessWidget {
  final String? settingsGroupTitle;
  final TextStyle? settingsGroupTitleStyle;
  final List<Widget> items;
  // Icons size
  final double iconItemSize;

  NastavitveGroup(
      {this.settingsGroupTitle,
      this.settingsGroupTitleStyle,
      this.items = const [],
      this.iconItemSize = 25});

  @override
  Widget build(BuildContext context) {
    SettingsScreenUtils.settingsGroupIconSize = iconItemSize;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      constraints:
          BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The title
          (settingsGroupTitle != null)
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    settingsGroupTitle!,
                    style: (settingsGroupTitleStyle == null)
                        ? TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                        : settingsGroupTitleStyle,
                  ),
                )
              : Container(),
          // The SettingsGroup sections
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
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
