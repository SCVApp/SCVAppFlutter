import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/components/EPAS/adminHome/list.dart';
import 'package:scv_app/components/EPAS/adminHome/title.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

class EPASAdminHome extends StatefulWidget {
  @override
  _EPASAdminHomeState createState() => _EPASAdminHomeState();
}

class _EPASAdminHomeState extends State<EPASAdminHome> {
  void goBack() {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    windowManager.hideWindow("EPAS");
    StoreProvider.of<AppState>(context).dispatch(windowManager);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadMyWorkshops();
    });
  }

  void loadMyWorkshops() async {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions("EPAS");
    epasApi.loading = true;
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
    await Future.wait(
        [epasApi.loadTimetables(), epasApi.loadLeaderWorkshops()]);
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
    final promisses = epasApi.workshops.map((workshop) async {
      await workshop.getCountAndMaxUsers();
    });
    await Future.wait(promisses);
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: EPASStyle.backgroundColor,
        body: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EPASAdminHomeTitle(context, goBack),
                EPASAdminHomeList(context)
              ],
            )));
  }
}
