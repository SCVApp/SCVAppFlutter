import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EasistentPage extends StatefulWidget{
  EasistentPage({Key key, this.title}) : super(key: key);

  final String title;

  _EasistentPageState createState() => _EasistentPageState();
}

class _EasistentPageState extends State<EasistentPage>{

  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context){
      return new WebView(
        initialUrl: "https://www.easistent.com/",javascriptMode: JavascriptMode.unrestricted,gestureRecognizers: Set(),
        );
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)