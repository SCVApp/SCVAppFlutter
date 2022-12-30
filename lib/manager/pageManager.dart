import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/pages/Login/intro.dart';
import 'package:scv_app/pages/Login/login.dart';
import 'package:scv_app/pages/loading.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:scv_app/global/global.dart' as global;

import '../pages/home.dart';

class PageManager extends StatefulWidget {
  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadToken();
    });
  }

  void loadToken() async {
    await global.token.loadToken();
    if (global.token.accessToken != null) {
      await loadFromCache();
      await global.token.refresh();
      final User user = StoreProvider.of<AppState>(context).state.user;
      await user.fetchAll();
      StoreProvider.of<AppState>(context).dispatch(user);
    } else {
      final User user = StoreProvider.of<AppState>(context).state.user;
      user.loggedIn = false;
      user.loading = false;
      user.loadingFromWeb = false;
      StoreProvider.of<AppState>(context).dispatch(user);
    }
  }

  Future<void> loadFromCache() async {
    final User user = StoreProvider.of<AppState>(context).state.user;
    await Future.wait([
      user.loadFromCache(),
      user.school.loadFromCache(),
    ]);
    StoreProvider.of<AppState>(context).dispatch(user);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return user.loading
            ? LoadingPage()
            : user.loggedIn
                ? HomePage()
                : user.logingIn
                    ? LoginPage()
                    : LoginIntro();
      },
    );
  }
}
