import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/components/EPAS/alert.dart';
import 'package:scv_app/components/EPAS/home/list.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/info.dart';
import 'package:scv_app/pages/EPAS/style.dart';

import '../../api/windowManager/windowManager.dart';
import '../../store/AppState.dart';

class EPASHomePage extends StatefulWidget {
  @override
  _EPASHomePageState createState() => _EPASHomePageState();
}

class _EPASHomePageState extends State<EPASHomePage> {
  void goBack() {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    windowManager.hideWindow("EPAS");
    StoreProvider.of<AppState>(context).dispatch(windowManager);
  }

  void viewInfo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EPASInfoPage()));
  }

  void loadTimetables() async {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;
    epasApi.loading = true;
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
    await Future.wait([epasApi.loadTimetables(), epasApi.loadUserCode()]);
    await epasApi.loadJoinedWorkshops();
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadTimetables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: EPASStyle.backgroundColor,
        bottomSheet: EPASAlertContainer(),
        body: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BackButton(
                        onPressed: goBack,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    IconButton(
                      onPressed: viewInfo,
                      icon: Icon(Icons.info_outline),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              EPASHomeList(context)
            ],
          ),
        ));
  }
}
