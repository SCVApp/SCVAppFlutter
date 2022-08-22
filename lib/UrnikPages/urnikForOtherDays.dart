import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrnikForOtherDays extends StatefulWidget {
  UrnikForOtherDays({Key key, this.urlString}) : super(key: key);

  final String urlString;

  _UrnikForOtherDays createState() => _UrnikForOtherDays();
}

class _UrnikForOtherDays extends State<UrnikForOtherDays> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Padding(
          child: WebView(
            initialUrl: widget.urlString,
            javascriptMode: JavascriptMode.unrestricted,
          ),
          padding: EdgeInsets.only(top: 40),
        ),
        backButton(context),
      ],
    )));
  }
}
