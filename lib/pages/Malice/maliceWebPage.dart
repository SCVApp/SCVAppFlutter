import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MaliceWebPage extends StatefulWidget {
  @override
  _MaliceWebPageState createState() => _MaliceWebPageState();
}

class _MaliceWebPageState extends State<MaliceWebPage> {
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
