import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'data.dart';

class DomovPage extends StatefulWidget{
  DomovPage({Key key, this.title,this.data,this.schoolUrl}) : super(key: key);

  final String title;

  
  final Data data;
  String schoolUrl;

  _DomovPageState createState() => _DomovPageState();
}

class _DomovPageState extends State<DomovPage>{

  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();
    

  @override
  Widget build(BuildContext context){
      return Scaffold(
        body:WebView(initialUrl: widget.data.schoolData.schoolUrl,onWebViewCreated: (controler)=>{
        _myController = controler
      },javascriptMode: JavascriptMode.unrestricted,),floatingActionButton: FloatingActionButton(onPressed: changeUrl,child: Icon(Icons.home),backgroundColor: widget.data.izbranaSola.color,));
  }

  void changeUrl(){
    _myController.loadUrl(widget.data.izbranaSola.noviceUrl);
  }

  
}

// WebView(initialUrl: widget.data.izbranaSola.noviceUrl,);