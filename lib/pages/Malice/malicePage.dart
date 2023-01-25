import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MalicePage extends StatefulWidget {
  @override
  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: WebView(
        initialUrl: 'https://malice.scv.si',
        javascriptMode: JavascriptMode.unrestricted,
        gestureRecognizers: Set(),
      ),
    );
  }
}
