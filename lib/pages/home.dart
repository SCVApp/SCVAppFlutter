import 'dart:async';

import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/bottomMenu.dart';
import 'package:scv_app/components/NavBarItem.dart';
import 'package:scv_app/components/alertContainer.dart';
import 'package:scv_app/pages/loading.dart';

import '../api/user.dart';
import '../store/AppState.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  HomePage({Key? key}) : super(key: key);
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  final int numOfTabs = 5;
  late final StreamSubscription<AppState> subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscription =
          StoreProvider.of<AppState>(context).onChange.listen((state) {
        if (state.user.selectedTab != _pageController.page!.toInt()) {
          _pageController.jumpToPage(state.user.selectedTab);
        }
      });
    });
    loadBottomMenu();
  }

  void loadBottomMenu() async {
    BottomMenu bottomMenu =
        StoreProvider.of<AppState>(context, listen: false).state.bottomMenu;
    await Future.wait(
        [bottomMenu.getMainMenuItems(), bottomMenu.getMoreMenuItems()]);

    StoreProvider.of<AppState>(context, listen: false).dispatch(bottomMenu);
  }

  void onSelectTab(int index) {
    if (index < numOfTabs && index >= 0) {
      User user = StoreProvider.of<AppState>(context).state.user;
      user.setTab(index);
      StoreProvider.of<AppState>(context).dispatch(user);
      _pageController.jumpToPage(index);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state.user.selectedTab == 0
              ? state.user.school.schoolColor
              : Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
              child: PageView(
            controller: _pageController,
            children: state.bottomMenu.pages,
            physics: NeverScrollableScrollPhysics(),
          )),
          bottomSheet: AlertContainer(),
          bottomNavigationBar: state.bottomMenu.mainMenu.length < 2
              ? LoadingPage(color: state.user.school.schoolColor)
              : FFNavigationBar(
                  onSelectTab: onSelectTab,
                  selectedIndex: state.user.selectedTab,
                  items: [
                    for (BottomMenuItem item in state.bottomMenu.mainMenu)
                      NavBarItem(
                        iconData: item.icon,
                        label: item.label(context),
                      ),
                  ],
                  theme: FFNavigationBarTheme(
                    barBackgroundColor:
                        Theme.of(context).bottomAppBarTheme.color,
                    selectedItemBorderColor:
                        Theme.of(context).bottomAppBarTheme.color,
                    selectedItemBackgroundColor: state.user.school.schoolColor,
                    selectedItemIconColor:
                        Theme.of(context).bottomAppBarTheme.color ??
                            Colors.white,
                    selectedItemLabelColor: Theme.of(context).primaryColor,
                  ),
                ),
        );
      },
    );
  }
}
