import 'package:flutter/material.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:scv_app/UrnikPages/detailUrnik.dart';
import 'package:scv_app/UrnikPages/mainUrnik.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/data.dart';

class UrnikPage extends StatefulWidget {
  UrnikPage({Key key, this.data, this.cacheData}) : super(key: key);

  Data data;
  final CacheData cacheData;
  updateData(Data updateData) {
    data = updateData;
  }

  _UrnikPageState createState() => _UrnikPageState();
}

class _UrnikPageState extends State<UrnikPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReloadSchedule();
  }

  void getReloadSchedule() async {
    if (widget.data != null) {
      if (widget.data.ureUrnikData.canGetFromWeb()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString(keyForAccessToken);
        print("State changing");
        await widget.data.ureUrnikData.getFromWeb(accessToken);
      }
      setState(() {});
      print("State changed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainUrnikPage(
      ureUrnikData: widget.data != null
          ? widget.data.ureUrnikData
          : widget.cacheData.ureUrnikData,
      urnikData: widget.data != null
          ? widget.data.urnikData
          : widget.cacheData.urnikData,
      schoolColor: widget.data != null
          ? widget.data.schoolData.schoolColor
          : widget.cacheData.schoolColor,
      data: widget.data,
      cacheData: widget.cacheData,
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