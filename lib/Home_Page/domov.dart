import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Data/data.dart';

class DomovPage extends StatefulWidget {
  DomovPage({Key key, this.title, this.data, this.schoolUrl, this.cacheData})
      : super(key: key);

  final String title;

  Data data;
  final CacheData cacheData;
  updateData(Data updateData) {
    data = updateData;
  }

  String schoolUrl;

  _DomovPageState createState() => _DomovPageState();
}

class _DomovPageState extends State<DomovPage> {
  WebViewController _myController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
          initialUrl: widget.data != null
              ? widget.data.schoolData.schoolUrl
              : widget.cacheData.schoolUrl,
          onWebViewCreated: (controler) => {_myController = controler},
          javascriptMode: JavascriptMode.unrestricted,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: changeUrl,
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
          backgroundColor: widget.data != null
              ? widget.data.schoolData.schoolColor
              : widget.cacheData.schoolColor,
        ));
  }

  void changeUrl() {
    _myController.loadUrl(widget.data != null
        ? widget.data.schoolData.schoolUrl
        : widget.cacheData.schoolUrl);
  }
}

// WebView(initialUrl: widget.data.izbranaSola.noviceUrl,);