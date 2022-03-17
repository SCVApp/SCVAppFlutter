import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MalicePage extends StatefulWidget{
  MalicePage({Key key, this.title}) : super(key: key);

  final String title;

  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage>{

  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context){
      return new WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
        _myController = c;
      },onPageFinished: (String url){
          readJS();
      },);
  }


  void readJS() async{
    await _myController.evaluateJavascript("let arr=[]");
    await _myController.evaluateJavascript("document.querySelectorAll(\"div\").forEach(e=>{\nif(!e.firstElementChild){\n  arr.push(e.innerText);\n}\n})");
    var html = await _myController.evaluateJavascript("arr.find(e=>e.includes(\"PIN\"))");
    print(html);
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)