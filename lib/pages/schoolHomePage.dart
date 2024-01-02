import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api/user.dart';
import '../store/AppState.dart';

class SchoolHomePage extends StatefulWidget {
  @override
  _SchoolHomePageState createState() => _SchoolHomePageState();
}

class _SchoolHomePageState extends State<SchoolHomePage> {
  late WebViewController _myController;

  void changeUrl() {
    final User user = StoreProvider.of<AppState>(context).state.user;
    if (user.school.schoolUrl != "") {
      _myController.loadUrl(user.school.schoolUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user,
        builder: (context, user) {
          return Scaffold(
              body: WebView(
                initialUrl: user.school.schoolUrl,
                onWebViewCreated: (controler) => {_myController = controler},
                javascriptMode: JavascriptMode.unrestricted,
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
