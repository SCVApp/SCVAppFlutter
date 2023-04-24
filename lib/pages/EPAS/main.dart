import 'package:flutter/material.dart';
import 'package:scv_app/pages/EPAS/adminHome.dart';
import 'package:scv_app/pages/EPAS/home.dart';

class EPASMainPage extends StatefulWidget {
  @override
  _EPASMainPageState createState() => _EPASMainPageState();
}

class _EPASMainPageState extends State<EPASMainPage> {
  final PageController pageController = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
    return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          EPASHomePage(),
          EPASAdminHome(),
        ]);
  }
}
