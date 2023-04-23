import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/components/EPAS/alert.dart';
import 'package:scv_app/components/EPAS/timetableSelection/list.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:scv_app/pages/EPAS/style.dart';
import 'package:scv_app/pages/EPAS/workshopSelection.dart';
import 'package:scv_app/store/AppState.dart';

import '../../api/epas/EPAS.dart';

class EPASTimetableSelection extends StatefulWidget {
  EPASTimetableSelection(this.timetableId, this.workshopId, {Key key})
      : super(key: key);
  final int workshopId;
  final int timetableId;
  @override
  _EPASTimetableSelectionState createState() => _EPASTimetableSelectionState();
}

class _EPASTimetableSelectionState extends State<EPASTimetableSelection> {
  int selectedTimetable = 0;
  int selectedWorkshopId = 0;
  void goBack() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            EPASWorkshopSelection(widget.timetableId),
        transitionsBuilder: (context, animation1, animation2, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation1),
          child: child,
        ),
      ),
    );
  }

  void onWidgetBuild() {
    loadWorkshopsWithSameName();
  }

  void loadWorkshopsWithSameName() async {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions("EPAS");
    final EPASWorkshop workshop = epasApi.workshops.firstWhere(
        (workshop) => workshop.id == widget.workshopId,
        orElse: () => null);
    final String workshopName = workshop.name;
    epasApi.loading = true;
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
    await epasApi.loadWorkshopsByName(workshopName);
    final prommises = <Future>[];
    for (EPASWorkshop workshop in epasApi.workshops) {
      prommises.add(workshop.getCountAndMaxUsers());
    }
    await Future.wait(prommises);
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onWidgetBuild();
    });
    setState(() {
      selectedTimetable = widget.timetableId;
      selectedWorkshopId = widget.workshopId;
    });
  }

  void changeCurrentSelectedTimetable(int newTimetableId, int newWorkshopId) {
    setState(() {
      selectedTimetable = newTimetableId;
      selectedWorkshopId = newWorkshopId;
    });
  }

  void handleError(e) {
    try {
      final String error = e.toString().replaceFirst("Exception: ", "");
      final dynamic errorObj = jsonDecode(error);
      final String message = errorObj["message"];
      if (message == "You can't join two workshops with the same name") {
        final int workshopWithSameNameId = errorObj["workshopWithSameNameId"];
        EPASWorkshop.errorJoinWithSameName(
            context, joinWorkshop, workshopWithSameNameId);
        return;
      }
      EPASApi.showAlert(message, false);
    } catch (err) {}
  }

  void joinWorkshop(
      {String successMessage = "Prijava na delavnico uspešna!"}) async {
    try {
      if (await EPASApi.joinWorkshop(selectedWorkshopId)) {
        final ExtensionManager extensionManager =
            StoreProvider.of<AppState>(context).state.extensionManager;
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");
        EPASApi.showAlert(successMessage, true);
        StoreProvider.of<AppState>(context).dispatch(extensionManager);
        await epasApi.loadJoinedWorkshops();
        StoreProvider.of<AppState>(context).dispatch(extensionManager);
        Navigator.pop(context);
      }
    } catch (e) {
      this.handleError(e);
      await this.loadWorkshopsWithSameName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EPASStyle.backgroundColor,
      bottomSheet: EPASAlertContainer(),
      body: SafeArea(
          bottom: false,
          child: StoreConnector<AppState, ExtensionManager>(
              converter: (store) => store.state.extensionManager,
              builder: (context, extensionManager) {
                final EPASApi epasApi = extensionManager.getExtensions("EPAS");
                final EPASWorkshop workshop = epasApi.workshops.firstWhere(
                    (workshop) => workshop.id == widget.workshopId,
                    orElse: () => null);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButton(onPressed: goBack),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            workshop.name.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ]),
                    EPASTimetableSelectionList(
                        context, selectedTimetable, selectedWorkshopId,
                        changeSelectedTimetableId:
                            changeCurrentSelectedTimetable,
                        joinWorkshop: joinWorkshop),
                  ],
                );
              })),
    );
  }
}
