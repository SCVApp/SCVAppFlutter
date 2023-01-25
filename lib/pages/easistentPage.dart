import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class EasistentPage extends StatefulWidget {
  @override
  _EasistentPageState createState() => _EasistentPageState();
}

class _EasistentPageState extends State<EasistentPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://easistent.com',
        javascriptMode: JavascriptMode.unrestricted,
        gestureRecognizers: Set(),
      ),
    );
  }
}
