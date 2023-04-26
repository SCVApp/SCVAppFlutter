import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/components/EPAS/adminHome/list.dart';
import 'package:scv_app/components/EPAS/adminHome/title.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/adminChechView.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';

class EPASAdminHome extends StatefulWidget {
  @override
  _EPASAdminHomeState createState() => _EPASAdminHomeState();
}

class _EPASAdminHomeState extends State<EPASAdminHome> {
  int currentSelectedWorkshopId = 0;
  int userCode = 0;
  void goBack() {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    windowManager.hideWindow("EPAS");
    StoreProvider.of<AppState>(context).dispatch(windowManager);
  }

  void getCodeFromUrl() {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    final attributes = windowManager.getAttributes("EPAS");

    try {
      final int code = int.parse(attributes["code"]);
      setCode(code);
    } catch (e) {}
    windowManager.removeAttributes("EPAS");
    StoreProvider.of<AppState>(context).dispatch(windowManager);
  }

  void setSelectedWorkshopId() {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions("EPAS");
    if (epasApi.workshops.length > 0) {
      setState(() {
        currentSelectedWorkshopId = epasApi.workshops[0].id;
      });
    }
    getCodeFromUrl();
  }

  void setCode(int newCode) {
    if (newCode.toString().length != 6) return;
    setState(() {
      userCode = newCode;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EPASAdminChechView(newCode, currentSelectedWorkshopId)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadMyWorkshops();
      StoreProvider.of<AppState>(context).onChange.listen((state) {
        final WindowManager windowManager = state.windowManager;
        final attributes = windowManager.getAttributes("EPAS");
        if (attributes["code"] != null) {
          getCodeFromUrl();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeSelectedWorkshop(int newWorkshopId) {
    setState(() {
      currentSelectedWorkshopId = newWorkshopId;
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
    setSelectedWorkshopId();
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
                EPASAdminHomeTitle(context, goBack, currentSelectedWorkshopId),
                EPASAdminHomeList(context, changeSelectedWorkshop,
                    currentSelectedWorkshopId, setCode)
              ],
            )));
  }
}
