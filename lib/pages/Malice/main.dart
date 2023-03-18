import 'package:flutter/material.dart';
import 'package:scv_app/pages/Malice/home.dart';
import 'package:scv_app/pages/Malice/login.dart';

class MalicePage extends StatefulWidget {
  @override
  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: PageView(
          children: <Widget>[MaliceHomePage(), MaliceLoginPage()],
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
