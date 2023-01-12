import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/pages/Login/intro.dart';
import 'package:scv_app/pages/Login/login.dart';
import 'package:scv_app/pages/loading.dart';
import 'package:scv_app/pages/lockPage.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:scv_app/global/global.dart' as global;

import '../api/appTheme.dart';
import '../pages/home.dart';

class PageManager extends StatefulWidget {
  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadToken();
      loadAppTheme();
      loadBiometric();
    });
    WidgetsBinding.instance.addObserver(this);
    global.globalBuildContext = context;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void loadToken() async {
    await global.token.loadToken();
    if (global.token.accessToken != null) {
      await loadFromCache();
      await global.token.refresh();
      final User user = StoreProvider.of<AppState>(context).state.user;
      try {
        await user.fetchAll();
      } catch (e) {
        global.showGlobalAlert(
            text: "Prišlo je do napake pri nalaganju podatkov.");
      }
      StoreProvider.of<AppState>(context).dispatch(user);
      await refreshUrnik();
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
    try {
      await Future.wait([
        user.loadFromCache(),
        user.school.loadFromCache(),
      ]);
    } catch (e) {
      global.showGlobalAlert(
          text: "Prišlo je do napake pri nalaganju podatkov.");
    }
    StoreProvider.of<AppState>(context).dispatch(user);
  }

  void loadAppTheme() async {
    final AppTheme appTheme =
        StoreProvider.of<AppState>(context).state.appTheme;
    await appTheme.load();
    StoreProvider.of<AppState>(context).dispatch(appTheme);
  }

  void loadBiometric() async {
    final Biometric biometric =
        StoreProvider.of<AppState>(context).state.biometric;
    await biometric.load();
    biometric.isPaused = false;
    biometric.showLockScreen();
    await biometric.save();
    StoreProvider.of<AppState>(context).dispatch(biometric);
  }

  Future<void> refreshUrnik() async {
    final Urnik urnik = StoreProvider.of<AppState>(context).state.urnik;
    await urnik.load();
    StoreProvider.of<AppState>(context).dispatch(urnik);
    await urnik.refresh();
    StoreProvider.of<AppState>(context).dispatch(urnik);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final Biometric biometric =
          StoreProvider.of<AppState>(context).state.biometric;
      await biometric.load();
      if (biometric.isPaused == true) {
        biometric.showLockScreen(fromBackground: true);
        biometric.isPaused = false;
        await biometric.save();
      }
      StoreProvider.of<AppState>(context).dispatch(biometric);
      await global.token.refresh();
    } else if (state == AppLifecycleState.paused) {
      final Biometric biometric =
          StoreProvider.of<AppState>(context).state.biometric;
      await biometric.updateLastActivity(isPaused: true);
      StoreProvider.of<AppState>(context).dispatch(biometric);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return user.loading
            ? LoadingPage()
            : user.loggedIn
                ? mainPage()
                : user.logingIn
                    ? LoginPage()
                    : LoginIntro();
      },
    );
  }

  Widget mainPage() {
    return StoreConnector<AppState, Biometric>(
      converter: (store) => store.state.biometric,
      builder: (context, biometric) {
        return biometric.locked ? LockPage() : HomePage();
      },
    );
  }
}
