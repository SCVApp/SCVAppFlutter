import 'package:flutter/material.dart';
import 'package:scv_app/api/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EasistentPage extends StatefulWidget {
  @override
  _EasistentPageState createState() => _EasistentPageState();
}

class _EasistentPageState extends State<EasistentPage> {
  late final WebViewController _controller = getWebViewController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onBuild());
  }

  void onBuild() async {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://easistent.com"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: _controller,
        gestureRecognizers: Set(),
      ),
    );
  }
}
