import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/mainUrnik.dart';
import 'data.dart';

class UrnikPage extends StatefulWidget{
  UrnikPage({Key key, this.title,this.data,this.cacheData}) : super(key: key);

  final String title;

  Data data;
  final CacheData cacheData;
  updateData(Data updateData){
    data = updateData;
  }

  _UrnikPageState createState() => _UrnikPageState();
}

class _UrnikPageState extends State<UrnikPage>{

  @override
  Widget build(BuildContext context) {
    return MainUrnikPage(data: widget.data,);
  }
}

/*
  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context){
      return new WebView(initialUrl: widget.data!=null?widget.data.schoolData.urnikUrl:widget.cacheData.schoolSchedule,javascriptMode: JavascriptMode.unrestricted,onWebViewCreated:(WebViewController c){
        _myController = c;
      });
  }
*/