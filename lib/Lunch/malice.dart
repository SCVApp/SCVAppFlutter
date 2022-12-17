import 'package:flutter/material.dart';
import 'package:scv_app/MalicePages/prijavaMalice.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MalicePage extends StatefulWidget {
  MalicePage({Key key}) : super(key: key);

  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage> {
  @override
  Widget build(BuildContext context) {
    return new WebView(
        initialUrl: "https://malice.scv.si/",
        javascriptMode: JavascriptMode.unrestricted);
    // return MalicePrijavaPage();
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)