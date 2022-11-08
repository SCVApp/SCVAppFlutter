import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/components/boxForHour.dart';
import 'package:scv_app/UrnikPages/urnikData.dart';
import 'package:scv_app/UrnikPages/urnikForOtherDays.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/data.dart';
import 'components/boxForHours.dart';

class UrnikBoxStyle {
  final Color bgColor;
  final Color primaryTextColor; //1. , FIZ , C305
  final Color secundaryTextColor; //8.00-8.45

  UrnikBoxStyle({this.bgColor, this.primaryTextColor, this.secundaryTextColor});
}

class MainUrnikPage extends StatefulWidget {
  MainUrnikPage(
      {Key key,
      this.ureUrnikData,
      this.urnikData,
      this.schoolColor,
      this.data,
      this.cacheData})
      : super(key: key);

  final UreUrnikData ureUrnikData;
  final UrnikData urnikData;
  final Data data;
  final CacheData cacheData;
  final Color schoolColor;

  _MainUrnikPageState createState() => _MainUrnikPageState();
}

class _MainUrnikPageState extends State<MainUrnikPage> {
  final double gap = 15;
  String doNaslednjeUreTxt = "";
  int currectHourIndex = 0;
  bool jeSePouk = true;
  double bottomOffsetOfListView = 0;

  Timer timerZaUrnik;

  GlobalKey _keyForListView = GlobalKey();

  final ScrollController scrollController = new ScrollController();

  void scrollToCurrectBox(int scrollToIndex) {
    if (widget.urnikData != null && widget.ureUrnikData != null) {
      scrollController.animateTo(((60 + this.gap) * scrollToIndex),
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    }
  }

  void trenutnoNiPouka() {
    jeSePouk = false;
  }

  void onBuildFinished() {
    scrollToCurrectBox(currectHourIndex);
    if (currectHourIndex > 0) {
      try {
        RenderBox box =
            this._keyForListView.currentContext.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        double y = position.dy;
        double sizeOfScreen = box.size.height;
        setState(() {
          this.bottomOffsetOfListView = sizeOfScreen - 60;
        });
      } catch (e) {}
    }
  }

  @override
  void initState() {
    if (widget.urnikData != null && widget.ureUrnikData != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => this.onBuildFinished());
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
    if (timerZaUrnik != null) {
      timerZaUrnik.cancel();
    }
  }

  void goToUrnikForOtherDays() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UrnikForOtherDays(
                  urlString: widget.data != null
                      ? widget.data.schoolData.urnikUrl
                      : widget.cacheData.schoolSchedule,
                )));
  }

  Future<void> _onRefresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await widget.ureUrnikData
          .getFromWeb(prefs.getString(keyForAccessToken), force: true);
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ureUrnikData == null || widget.urnikData == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 5)),
          Padding(
              child: TitleNowOn(doNaslednjeUreTxt),
              padding: EdgeInsets.only(bottom: this.gap, left: 15, right: 15)),
          trenutnaUra(context),
          Padding(
            child: GestureDetector(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ogled urnika za ostale dni",
                        style: TextStyle(fontSize: 15),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                    ]),
                onTap: goToUrnikForOtherDays),
            padding: EdgeInsets.only(left: 15, right: 15, bottom: this.gap),
          ),
          Padding(
            child: Align(
              child: Text(
                "Današnji urnik",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.centerLeft,
            ),
            padding: EdgeInsets.only(bottom: this.gap, left: 15, right: 15),
          ),
          Padding(padding: EdgeInsets.only(bottom: this.gap)),
          Expanded(
              child: RefreshIndicator(
                  child: ListView(
                    key: _keyForListView,
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    padding:
                        EdgeInsets.only(bottom: this.gap, left: 15, right: 15),
                    children: [
                      for (Widget i in ShowHoursInDay(context)) i,
                      SizedBox(height: this.bottomOffsetOfListView),
                    ],
                  ),
                  onRefresh: _onRefresh,
                  color: widget.schoolColor)),
        ]));
  }

  Widget trenutnaUra(BuildContext context) {
    UraTrajanje trajanjeUra = widget.ureUrnikData != null
        ? widget.ureUrnikData.urnikUre.firstWhere(
            ((element) => element.style == widget.urnikData.nowStyle),
            orElse: () => null)
        : null;
    if (trajanjeUra != null) {
      return Padding(
        child: HoursBoxUrnik(
            urnikBoxStyle:
                widget.urnikData != null ? widget.urnikData.nowStyle : null,
            trajanjeUra: trajanjeUra,
            urnikData: widget.urnikData),
        padding: EdgeInsets.only(bottom: this.gap, left: 15, right: 15),
      );
    } else {
      String title = "";
      int length =
          widget.ureUrnikData != null ? widget.ureUrnikData.urnikUre.length : 0;
      if (length > 0) {
        int trenutniCas = DateTime.now().millisecondsSinceEpoch;
        int konecZadnjeUre = widget
            .ureUrnikData.urnikUre[length - 1].konec.millisecondsSinceEpoch;
        DateTime zacetekPrveUre = widget.ureUrnikData.urnikUre[0].zacetek;
        if (trenutniCas > konecZadnjeUre) {
          title = "Konec pouka";
          this.trenutnoNiPouka();
        } else if (trenutniCas < zacetekPrveUre.millisecondsSinceEpoch) {
          String zacetekH = zacetekPrveUre.hour < 10
              ? "0" + zacetekPrveUre.hour.toString()
              : zacetekPrveUre.hour.toString();
          String zacetekM = zacetekPrveUre.minute < 10
              ? "0" + zacetekPrveUre.minute.toString()
              : zacetekPrveUre.minute.toString();
          title = "Začetek pouka ob $zacetekH.$zacetekM";
        }
      }
      return Padding(
        child: HourBoxUrnik(
            urnikBoxStyle: widget.urnikData.nowStyle,
            context: context,
            mainTitle: title,
            urnikData: widget.urnikData),
        padding: EdgeInsets.only(bottom: this.gap, left: 15, right: 15),
      );
    }
  }

  List<Widget> ShowHoursInDay(BuildContext context) {
    List<Widget> hours = [];
    widget.ureUrnikData.prikaziTrenutnoUro(widget.urnikData);
    int i = 0;
    for (UraTrajanje uraTrajanje in this.widget.ureUrnikData.urnikUre) {
      Ura ura = uraTrajanje.ura.length >= 1 ? uraTrajanje.ura[0] : new Ura();
      if (uraTrajanje.style == widget.urnikData.nextStyle) {
        currectHourIndex = i;
      }
      hours.add(HoursBoxUrnik(
          isSmall: true,
          urnikBoxStyle: uraTrajanje.style,
          trajanjeUra: uraTrajanje,
          urnikData: widget.urnikData));
      hours.add(Padding(padding: EdgeInsets.only(bottom: this.gap)));
      i += 1;
    }
    return hours;
  }

  Widget TitleNowOn(String doNaslednjeUreTxt) {
    String naslednaUraText = "naslednje ure";
    if (widget.ureUrnikData.urnikUre.length > 0) {
      int trenutneMiliSec = DateTime.now().millisecondsSinceEpoch;
      int zacetekPrveUre =
          widget.ureUrnikData.urnikUre[0].zacetek.millisecondsSinceEpoch;
      if (zacetekPrveUre > trenutneMiliSec) {
        naslednaUraText = "začetek pouka";
      }
    }

    bool isNext = widget.ureUrnikData.zacetekNaslednjeUre != -1;
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          "Trenutno na urniku",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(padding: EdgeInsets.only(left: 5)),
        isNext
            ? Text(
                "($doNaslednjeUreTxt do $naslednaUraText):",
              )
            : SizedBox(),
      ],
    );
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