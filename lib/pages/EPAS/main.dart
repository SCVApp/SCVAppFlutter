import 'package:flutter/material.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/pages/EPAS/adminHome.dart';
import 'package:scv_app/pages/EPAS/home.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/pages/loading.dart';

class EPASMainPage extends StatefulWidget {
  @override
  _EPASMainPageState createState() => _EPASMainPageState();
}

class _EPASMainPageState extends State<EPASMainPage> {
  final PageController pageController = PageController(initialPage: 0);

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

  @override
  void initState() {
    super.initState();
    getRole();
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
