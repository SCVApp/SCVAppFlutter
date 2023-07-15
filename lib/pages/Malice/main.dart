import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/pages/Malice/home.dart';
import 'package:scv_app/pages/Malice/login.dart';
import 'package:scv_app/pages/Malice/otherInformations.dart';
import 'package:scv_app/pages/Malice/selectMenus.dart';
import 'package:scv_app/pages/loading.dart';
import 'package:scv_app/store/AppState.dart';

import '../../api/malice/malica.dart';

class MalicePage extends StatefulWidget {
  @override
  _MalicePageState createState() => _MalicePageState();
}

class _MalicePageState extends State<MalicePage> {
  PageController _pageController = PageController(initialPage: 0);

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onStateBuild());
  }

  void onStateBuild() async {
    await loadData();
  }

  void goToSelectMenu() {
    _pageController.jumpToPage(1);
  }

  void goToHomePage() {
    _pageController.jumpToPage(0);
  }

  void goToOtherInformations() {
    _pageController.jumpToPage(2);
  }

  Future<void> loadData() async {
    final Malica malica = StoreProvider.of<AppState>(context).state.malica;
    await malica.maliceUser.load();
    StoreProvider.of<AppState>(context).dispatch(malica);
    if (malica.maliceUser.isLoggedIn() == true) {
      await Future.wait(
          [malica.maliceUser.loadDataFromWeb(), malica.loadFirstDays()]);
      if (!mounted) return;
      StoreProvider.of<AppState>(context).dispatch(malica);
      setState(() {
        isLoaded = true;
      });
      return;
    }
    await tryMicrosoftLogin();
  }

  Future<void> tryMicrosoftLogin() async {
    final Malica malica = StoreProvider.of<AppState>(context).state.malica;
    if (malica.maliceUser.isLoggedIn() == true) {
      return;
    }
    await malica.maliceUser.loginWithMicrosoftToken();
    StoreProvider.of<AppState>(context).dispatch(malica);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return MaliceWebPage();
    return StoreConnector<AppState, Malica>(
      converter: (store) => store.state.malica,
      builder: (context, malica) {
        return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: !isLoaded
                ? LoadingPage()
                : malica.maliceUser.isLoggedIn() != false
                    ? MaliceLoginPage()
                    : PageView(
                        controller: _pageController,
                        children: <Widget>[
                          MaliceHomePage(goToSelectMenu, goToOtherInformations),
                          MaliceSelectMenus(goToHomePage),
                          MaliceOtherInformations(goToHomePage),
                        ],
                        physics: NeverScrollableScrollPhysics(),
                      ));
      },
    );
  }
}
