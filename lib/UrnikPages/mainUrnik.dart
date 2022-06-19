import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/components/boxForHour.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data.dart';

class UrnikBoxStyle{
  final Color bgColor;
  final Color primaryTextColor; //1. , FIZ , C305
  final Color secundaryTextColor; //8.00-8.45

  UrnikBoxStyle({this.bgColor,this.primaryTextColor, this.secundaryTextColor});
}

class MainUrnikPage extends StatefulWidget{
  MainUrnikPage({Key key, this.data}) : super(key: key);

  final Data data;

  _MainUrnikPageState createState() => _MainUrnikPageState();
}

class _MainUrnikPageState extends State<MainUrnikPage>{
  final List<int> a = [1,2,3,4,5];
  final double gap = 15;
  
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 5)),
          Padding(child: TitleNowOn(), padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15)),
          Padding(child: HourBoxUrnik(urnikBoxStyle: widget.data.urnikData != null ? widget.data.urnikData.nowStyle : null),padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15),),
          Padding(child: Align(
            child: Text("Današnji urnik", style: TextStyle(fontWeight: FontWeight.bold),),
            alignment: Alignment.centerLeft,
          ), padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15),),
          Padding(padding: EdgeInsets.only(bottom: this.gap)),
          Expanded(child: ListView(
            padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15),
            children: [
              for(Widget i in ShowHoursInDay()) i,
              Padding(padding: EdgeInsets.only(bottom: 10)),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Ogled urnika za ostale dni", style: TextStyle (fontSize: 15),),
                  Icon(Icons.arrow_forward_ios, color: Colors.black,),
                ]),
              ),
              Padding(padding: EdgeInsets.only(bottom: 30))
            ],
          ))
        ]
      );
  }

  List<Widget> ShowHoursInDay(){
    List<Widget> hours = [];
    for(int i = 0; i < this.a.length; i++){
      UrnikBoxStyle style = widget.data.urnikData != null ? i == 0 ? widget.data.urnikData.nowStyle : i == 1 ? widget.data.urnikData.nextStyle : widget.data.urnikData.otherStyle : null;
      hours.add(HourBoxUrnik(isSmall: true, urnikBoxStyle: style));
      hours.add(Padding(padding: EdgeInsets.only(bottom: this.gap)));
    }
    return hours;
  }

  Widget TitleNowOn(){
    return LayoutBuilder(
      builder: (context, constraints) {
        var painter1 = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: 'Trenutno na urniku',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        var painter2 = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: '(5min in 40s do naslednje ure):',
            style: TextStyle(
            ),
          ),
        );
        painter1.layout();
        painter2.layout();
        bool isOverFlowing = painter1.size.width + painter2.size.width > constraints.maxWidth;
        return isOverFlowing ? 
        Column(
          children: [
            Text(painter1.text.toPlainText(),style: painter1.text.style,),
            Text(painter2.text.toPlainText(),style: painter2.text.style,),
        ],) : 
        Row(
          children: [
            Text(painter1.text.toPlainText(),style: painter1.text.style,),
            Text(painter2.text.toPlainText(),style: painter2.text.style,),
          ]
        );
    });
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