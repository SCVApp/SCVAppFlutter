import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/components/backButton.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrnikOtherDays extends StatefulWidget {
  @override
  _UrnikOtherDaysState createState() => _UrnikOtherDaysState();
}

class _UrnikOtherDaysState extends State<UrnikOtherDays> {
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
                child: WebView(
                  initialUrl: user.school.urnikUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
                padding: EdgeInsets.only(top: 40),
              ),
              backButton(context),
            ],
          )));
        });
  }
}
