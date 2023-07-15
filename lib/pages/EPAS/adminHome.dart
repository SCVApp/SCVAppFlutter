import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/api/windowManager/windowManager.dart';
import 'package:scv_app/components/EPAS/adminHome/list.dart';
import 'package:scv_app/components/EPAS/adminHome/title.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/adminChechView.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:collection/collection.dart';

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

  void getCodeFromUrl(int workshopId) {
    final WindowManager windowManager =
        StoreProvider.of<AppState>(context).state.windowManager;
    final attributes = windowManager.getAttributes("EPAS");

    try {
      final int code = int.parse(attributes["code"]);
      setCode(code, workshopId: workshopId);
    } catch (e) {}
    windowManager.removeAttributes("EPAS");
    StoreProvider.of<AppState>(context).dispatch(windowManager);
  }

  void setSelectedWorkshopId() {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;
    int workshopId = 0;
    if (epasApi.workshops.length > 0) {
      setState(() {
        currentSelectedWorkshopId = epasApi.workshops[0].id;
      });
      workshopId = epasApi.workshops[0].id;
    }

    for (EPASWorkshop workshop in epasApi.workshops) {
      final EPASTimetable? timetable = epasApi.timetables
          .firstWhereOrNull((element) => element.id == workshop.timetable_id);
      if (timetable == null) continue;
      DateTime now = DateTime.now();

      DateTime start = timetable.start.subtract(Duration(minutes: 10));
      if (now.isAfter(start) && now.isBefore(start)) {
        setState(() {
          currentSelectedWorkshopId = workshop.id;
        });
        workshopId = workshop.id;
      }
    }

    getCodeFromUrl(workshopId);
  }

  void setCode(int newCode, {int? workshopId}) {
    if (newCode.toString().length != 6) return;
    setState(() {
      userCode = newCode;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EPASAdminChechView(
                newCode, workshopId ?? currentSelectedWorkshopId)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadMyWorkshops();
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
    final EPASApi epasApi = extensionManager.getExtensions("EPAS") as EPASApi;
    epasApi.loading = true;
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
    await Future.wait(
        [epasApi.loadTimetables(), epasApi.loadLeaderWorkshops()]);
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
    checkForUrl();
    final promisses = epasApi.workshops.map((workshop) async {
      await workshop.getCountAndMaxUsers();
    });
    await Future.wait(promisses);
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }

  void checkForUrl() {
    setSelectedWorkshopId();
    StoreProvider.of<AppState>(context).onChange.listen((state) {
      final WindowManager windowManager = state.windowManager;
      final attributes = windowManager.getAttributes("EPAS");
      if (attributes["code"] != null) {
        setSelectedWorkshopId();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: EPASStyle.backgroundColor,
        resizeToAvoidBottomInset: false,
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
