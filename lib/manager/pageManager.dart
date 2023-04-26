import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/alert.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/api/user.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/manager/universalLinks.dart' as universalLinks;
import 'package:scv_app/pages/EPAS/main.dart';
import 'package:scv_app/pages/Login/intro.dart';
import 'package:scv_app/pages/Login/login.dart';
import 'package:scv_app/pages/PassDoor/unlock.dart';
import 'package:scv_app/pages/loading.dart';
import 'package:scv_app/pages/lockPage.dart';
import 'package:scv_app/store/AppState.dart';

import '../api/appTheme.dart';
import '../pages/home.dart';

class PageManager extends StatefulWidget {
  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> with WidgetsBindingObserver {
  StreamSubscription<ConnectivityResult> connectivity;
  final PageController pageControllerForLock = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onWidgetDidBuild();
    });
    WidgetsBinding.instance.addObserver(this);
    global.globalBuildContext = context;

    try {
      connectivity = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        handleConnectivityChange();
      });
    } catch (e) {}
    universalLinks.initURIHandler(context);
    universalLinks.incomingURIHandler();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    if (connectivity != null) connectivity.cancel();
    if (universalLinks.universalLinkSubscription != null)
      universalLinks.universalLinkSubscription.cancel();
  }

  void onWidgetDidBuild() {
    StoreProvider.of<AppState>(context).onChange.listen((state) {
      onStateChange();
    });
    loadToken();
    loadAppTheme();
    loadBiometric();
  }

  void onStateChange() {
    final int currentPage = pageControllerForLock.page.round();
    final bool locked =
        StoreProvider.of<AppState>(context).state.biometric.locked;
    int nextPage = locked ? 1 : 0;
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    if (!locked && windowManager.haveToChangeWindow(currentPage)) {
      nextPage = windowManager.getIndexOfWindow();
    } else if (!locked && windowManager.getIndexOfWindow() != 0) {
      return;
    }
    if (currentPage != nextPage) {
      pageControllerForLock.jumpToPage(nextPage);
    }
  }

  void handleConnectivityChange() async {
    await Future.delayed(Duration(seconds: 1));

    GlobalAlert globalAlert =
        StoreProvider.of<AppState>(context).state.globalAlert;
    if (await global.canConnectToNetwork() == true) {
      if (globalAlert.text == "Nimate internetne povezave") {
        globalAlert.hide();
        loadToken();
      }
    } else {
      globalAlert.show("Nimate internetne povezave", null, Icons.wifi_off);
      chechIfInternetConnectionIsBack();
    }
    StoreProvider.of<AppState>(context).dispatch(globalAlert);
  }

  void chechIfInternetConnectionIsBack() {
    //on new thread
    Future.delayed(Duration(seconds: 5), () {
      //on main thread
      handleConnectivityChange();
    });
  }

  void loadToken() async {
    await global.token.loadToken();
    universalLinks.goToUnlockPassDoor(context, universalLinks.universalLink);
    if (global.token.accessToken != null) {
      await loadFromCache();
      if (await global.canConnectToNetwork() == false) {
        handleConnectivityChange();
        return;
      }
      await global.token.refresh();
      final User user = StoreProvider.of<AppState>(context).state.user;
      try {
        await user.fetchAll();
      } catch (e) {
        global.showGlobalAlert(
            text: "Prišlo je do napake pri nalaganju podatkov.");
      }
      StoreProvider.of<AppState>(context).dispatch(user);
      await Future.wait([refreshUrnik()]);
      await loadAuthExtensions();
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

  Future<void> loadAuthExtensions() async {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    await extensionManager.checkAuth();
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }

  Future<void> refreshUrnik() async {
    final Urnik urnik = StoreProvider.of<AppState>(context).state.urnik;
    await urnik.load();
    urnik.preveriCeJeUrnikOsvezenDanes();
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
      universalLinks.goToUnlockPassDoor(context, universalLinks.universalLink);
      universalLinks.universalLink = "";
      await global.token.refresh();
      await refreshUrnik();
    } else if (state == AppLifecycleState.paused) {
      universalLinks.universalLink = "";
      universalLinks.goToUnlockPassDoor(context, "", close: true);
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).primaryColor == Colors.white
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: PageView(
          controller: this.pageControllerForLock,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            LockPage(),
            UnlockedPassDoor(),
            EPASMainPage(),
          ],
        ));
  }
}
