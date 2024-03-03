import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/EventTracking.dart';
import 'package:scv_app/api/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api/user.dart';
import '../store/AppState.dart';

class SchoolHomePage extends StatefulWidget {
  @override
  _SchoolHomePageState createState() => _SchoolHomePageState();
}

class _SchoolHomePageState extends State<SchoolHomePage> {
  late final WebViewController _controller = getWebViewController();
  late final StreamSubscription<AppState> subscription;

  void changeUrl() {
    final User user = StoreProvider.of<AppState>(context).state.user;
    if (user.school.schoolUrl != "") {
      _controller..loadRequest(Uri.parse(user.school.schoolUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    EventTracking.trackScreenView("schoolHomePage", "SchoolHomePage");
    WidgetsBinding.instance.addPostFrameCallback((_) => onBuild());
  }

  void onBuild() async {
    final User user = StoreProvider.of<AppState>(context).state.user;
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(user.school.getLoadUrl()));
    // subscription = user.
    // listen for user.school.newsUrl changes
    subscription = StoreProvider.of<AppState>(context).onChange.listen((state) {
      if (state.user.school.newsUrl != null) {
        _controller..loadRequest(Uri.parse(state.user.school.newsUrl!));
        state.user.school.removeNewsUrl();
      }
    });
  }

  dispose() {
    if (subscription != null) subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user,
        builder: (context, user) {
          return Scaffold(
              body: WebViewWidget(
                controller: _controller,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: changeUrl,
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                backgroundColor: user.school.schoolColor,
              ));
        });
  }
}
