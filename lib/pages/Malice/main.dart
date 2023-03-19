import 'package:flutter/material.dart';
import 'package:scv_app/pages/Malice/home.dart';
import 'package:scv_app/pages/Malice/login.dart';
import 'package:scv_app/pages/Malice/selectMenus.dart';

class MalicePage extends StatefulWidget {
  @override
  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage> {
  PageController _pageController = PageController(initialPage: 0);

  void goToSelectMenu() {
    _pageController.jumpToPage(2);
  }

  void goToHomePage() {
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            MaliceHomePage(goToSelectMenu),
            MaliceLoginPage(),
            MaliceSelectMenus(goToHomePage)
          ],
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
