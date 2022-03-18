import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'data.dart';

class UrnikPage extends StatefulWidget{
  UrnikPage({Key key, this.title,this.data}) : super(key: key);

  final String title;

  final Data data;

  _UrnikPageState createState() => _UrnikPageState();
}

class _UrnikPageState extends State<UrnikPage>{
  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context){
      return new WebView(initialUrl: widget.data.izbranaSola.urnikUrl,javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
        _myController = c;
      });
  }
}