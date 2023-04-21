import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/components/EPAS/halfScreenCard.dart';
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onWidgetBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EPASStyle.backgroundColor,
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
                    EPASTimetableSelectionList(context, widget.timetableId)
                  ],
                );
              })),
    );
  }
}
