import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/api/webview.dart';
import 'package:scv_app/components/backButton.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrnikOtherDays extends StatefulWidget {
  @override
  _UrnikOtherDaysState createState() => _UrnikOtherDaysState();
}

class _UrnikOtherDaysState extends State<UrnikOtherDays> {
  late final WebViewController _controller = getWebViewController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onBuild());
  }

  void onBuild() async {
    final User user =
        StoreProvider.of<AppState>(context, listen: false).state.user;
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(user.school.urnikUrl));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user,
        builder: (context, user) {
          return Scaffold(
              body: SafeArea(
                  child: Stack(
            children: [
              Padding(
                child: WebViewWidget(
                  controller: _controller,
                ),
                padding: EdgeInsets.only(top: 40),
              ),
              backButton(context),
            ],
          )));
        });
  }
}
