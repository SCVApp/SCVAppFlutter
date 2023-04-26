import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/adminHome.dart';
import 'package:scv_app/pages/EPAS/home.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/pages/loading.dart';

import '../../store/AppState.dart';

class EPASMainPage extends StatefulWidget {
  @override
  _EPASMainPageState createState() => _EPASMainPageState();
}

class _EPASMainPageState extends State<EPASMainPage> {
  final PageController pageController = PageController(initialPage: 0);
  Timer timer;

  void getRole() async {
    try {
      final response = await http.get(
          Uri.parse('${EPASApi.EPASapiUrl}/user/role'),
          headers: <String, String>{
            'Authorization': '${global.token.accessToken}',
          });
      if (response.statusCode == 200) {
        if (response.body == 'vodja') {
          pageController.jumpToPage(2);
        } else {
          pageController.jumpToPage(1);
        }
      }
    } catch (e) {}
  }

  void refreshJoinedWorkshops() async {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions("EPAS");
    if (this.pageController.page == 1) {
      await epasApi.loadJoinedWorkshops();
    }
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }

  @override
  void initState() {
    super.initState();
    getRole();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      this.timer = Timer.periodic(
          Duration(seconds: 5), (Timer t) => refreshJoinedWorkshops());
    });
  }

  @override
  void dispose() {
    if (this.timer != null) this.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          LoadingPage(color: EPASStyle.backgroundColor),
          EPASHomePage(),
          EPASAdminHome(),
        ]);
  }
}
