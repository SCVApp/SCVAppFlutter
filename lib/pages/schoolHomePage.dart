import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  void changeUrl() {
    final User user = StoreProvider.of<AppState>(context).state.user;
    if (user.school.schoolUrl != "") {
      _controller..loadRequest(Uri.parse(user.school.schoolUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onBuild());
  }

  void onBuild() async {
    final User user = StoreProvider.of<AppState>(context).state.user;
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(user.school.schoolUrl));
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
