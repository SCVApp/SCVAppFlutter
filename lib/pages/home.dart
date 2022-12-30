import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/NavBarItem.dart';
import 'package:scv_app/pages/Malice/malicePage.dart';
import 'package:scv_app/pages/Nastavitve/main.dart';
import 'package:scv_app/pages/Urnik/main.dart';
import 'package:scv_app/pages/easistentPage.dart';
import 'package:scv_app/pages/schoolHomePage.dart';

import '../api/user.dart';
import '../icons/ea_icon.dart';
import '../store/AppState.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  HomePage({Key key}) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  final int numOfTabs = 5;

  @override
  void initState() {
    super.initState();
  }

  void onSelectTab(int index) {
    if (index < numOfTabs && index >= 0) {
      setState(() {
        selectedTab = index;
      });
    }
  }

  final List<Widget> _children = [
    SchoolHomePage(),
    MalicePage(),
    EasistentPage(),
    UrnikPage(),
    NastavitvePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return Scaffold(
          backgroundColor: selectedTab == 0
              ? user.school.schoolColor
              : Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: _children[selectedTab],
          ),
          bottomNavigationBar: FFNavigationBar(
            onSelectTab: onSelectTab,
            selectedIndex: selectedTab,
            items: [
              NavBarItem(
                iconData: Icons.home_rounded,
                label: 'Domov',
              ),
              NavBarItem(
                iconData: Icons.fastfood,
                label: 'Malice',
              ),
              NavBarItem(
                iconData: FluttereAIcon.ea,
                label: 'eAsistent',
              ),
              NavBarItem(
                iconData: Icons.calendar_today_rounded,
                label: 'Urnik',
              ),
              NavBarItem(
                iconData: Icons.settings,
                label: 'Nastavitve',
              ),
            ],
            theme: FFNavigationBarTheme(
              barBackgroundColor: Theme.of(context).bottomAppBarColor,
              selectedItemBorderColor: Theme.of(context).bottomAppBarColor,
              selectedItemBackgroundColor: user.school.schoolColor,
              selectedItemIconColor: Theme.of(context).bottomAppBarColor,
              selectedItemLabelColor: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }
}
