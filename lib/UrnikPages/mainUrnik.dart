import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/components/boxForHour.dart';
import 'package:scv_app/UrnikPages/urnikData.dart';
import 'package:scv_app/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data.dart';

class UrnikBoxStyle{
  final Color bgColor;
  final Color primaryTextColor; //1. , FIZ , C305
  final Color secundaryTextColor; //8.00-8.45

  UrnikBoxStyle({this.bgColor,this.primaryTextColor, this.secundaryTextColor});
}

class MainUrnikPage extends StatefulWidget{
  MainUrnikPage({Key key, this.ureUrnikData, this.urnikData, this.schoolColor}) : super(key: key);

  final UreUrnikData ureUrnikData;
  final UrnikData urnikData;
  final Color schoolColor;

  _MainUrnikPageState createState() => _MainUrnikPageState();
}

class _MainUrnikPageState extends State<MainUrnikPage>{
  
  final double gap = 15;
  String doNaslednjeUreTxt = "";
  int currectHourIndex = 0;
  bool jeSePouk = true;
  double bottomOffsetOfListView = 0;

  Timer timerZaUrnik;

  GlobalKey _keyForListView = GlobalKey();

  final ScrollController scrollController = new ScrollController();

  void scrollToCurrectBox(int scrollToIndex){
    if(widget.urnikData != null && widget.ureUrnikData != null){
      scrollController.animateTo(((60+this.gap)*scrollToIndex), duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    }
  }

  void trenutnoNiPouka(){
    jeSePouk = false;
  }

  void onBuildFinished(){
    scrollToCurrectBox(currectHourIndex);
    if(currectHourIndex > 0){
      try{
          RenderBox box = this._keyForListView.currentContext.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);
          double y = position.dy;
          double sizeOfScreen = box.size.height;
          setState(() {
            this.bottomOffsetOfListView = sizeOfScreen - 120;
          });
      }catch(e){}
    }
  }

  @override
  void initState() {
    if(widget.urnikData != null && widget.ureUrnikData != null){
      WidgetsBinding.instance.addPostFrameCallback((_) => this.onBuildFinished());
      timerZaUrnik = Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          doNaslednjeUreTxt = widget.ureUrnikData.doNaslednjeUre();
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if(timerZaUrnik != null){
      timerZaUrnik.cancel();
    }
  }

  Future<void> _onRefresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      await widget.ureUrnikData.getFromWeb(prefs.getString(keyForAccessToken), force: true);
    }catch(e){
      print(e);
    }
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    if(widget.ureUrnikData == null || widget.urnikData == null){
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 5)),
          Padding(child: TitleNowOn(doNaslednjeUreTxt), padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15)),
          trenutnaUra(context),
          Padding(child: Align(
            child: Text("Današnji urnik", style: TextStyle(fontWeight: FontWeight.bold),),
            alignment: Alignment.centerLeft,
          ), padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15),),
          Padding(padding: EdgeInsets.only(bottom: this.gap)),
          Expanded(child:
            RefreshIndicator(
              key: _keyForListView,
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15),
                children: [
                  for(Widget i in ShowHoursInDay(context)) i,
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Ogled urnika za ostale dni", style: TextStyle (fontSize: 15),),
                      Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor,),
                    ]),
                  ),
                  SizedBox(height: this.bottomOffsetOfListView),
                ],
              ),
              onRefresh: _onRefresh,
              color: widget.schoolColor
            )
          )
        ]
      ));
  }

  Widget trenutnaUra(BuildContext context){
    UraTrajanje trajanjeUra = widget.ureUrnikData != null ? widget.ureUrnikData.urnikUre.firstWhere(((element) => element.style == widget.urnikData.nowStyle), orElse: () => null):null;
    if(trajanjeUra != null){

      return Padding(child: HourBoxUrnik(urnikBoxStyle: widget.urnikData != null ? widget.urnikData.nowStyle : null, trajanjeUra: trajanjeUra, context: context, urnikData: widget.urnikData),padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15),
      );
    }else{
      String title = "";
      int length = widget.ureUrnikData != null ? widget.ureUrnikData.urnikUre.length:0;
      if(length > 0){
        int trenutniCas = DateTime.now().millisecondsSinceEpoch;
        int konecZadnjeUre = widget.ureUrnikData.urnikUre[length-1].konec.millisecondsSinceEpoch;
        DateTime zacetekPrveUre = widget.ureUrnikData.urnikUre[0].zacetek;
        if(trenutniCas > konecZadnjeUre){
          title = "Konec pouka";
          this.trenutnoNiPouka();
        }else if(trenutniCas<zacetekPrveUre.millisecondsSinceEpoch){
          String zacetekH = zacetekPrveUre.hour < 10 ? "0"+zacetekPrveUre.hour.toString() : zacetekPrveUre.hour.toString();
          String zacetekM = zacetekPrveUre.minute < 10 ? "0"+zacetekPrveUre.minute.toString() : zacetekPrveUre.minute.toString();
          title = "Začetek pouka ob $zacetekH.$zacetekM";
        }
      }
      return Padding(child: HourBoxUrnik(urnikBoxStyle: widget.urnikData.nowStyle, context: context, mainTitle: title, urnikData: widget.urnikData),padding: EdgeInsets.only(bottom: this.gap,left: 15, right: 15),);
    }
  }

  List<Widget> ShowHoursInDay(BuildContext context){
    List<Widget> hours = [];
    widget.ureUrnikData.prikaziTrenutnoUro(widget.urnikData);
    int i = 0;
    for(UraTrajanje uraTrajanje in this.widget.ureUrnikData.urnikUre){
      Ura ura = uraTrajanje.ura.length >= 1 ? uraTrajanje.ura[0] : new Ura();
      if(uraTrajanje.style == widget.urnikData.nextStyle){
        currectHourIndex = i;
      }
      hours.add(HourBoxUrnik(isSmall: true, urnikBoxStyle: uraTrajanje.style, trajanjeUra: uraTrajanje, context: context, urnikData: widget.urnikData));
      hours.add(Padding(padding: EdgeInsets.only(bottom: this.gap)));
      i+=1;
    }
    return hours;
  }

  Widget TitleNowOn(String doNaslednjeUreTxt){
    return LayoutBuilder(
      builder: (context, constraints) {
        var painter1 = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: 'Trenutno na urniku ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        var painter2 = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: doNaslednjeUreTxt !="" ? '($doNaslednjeUreTxt do naslednje ure):':"",
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