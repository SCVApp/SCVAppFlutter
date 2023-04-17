import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/pages/EPAS/style.dart';

import '../../api/epas/EPAS.dart';
import '../../components/EPAS/workshopSelection/list.dart';
import '../../manager/extensionManager.dart';
import '../../store/AppState.dart';

class EPASWorkshopSelection extends StatefulWidget {
  EPASWorkshopSelection(this.timetableId, {Key key}) : super(key: key);
  final int timetableId;
  @override
  _EPASWorkshopSelectionState createState() => _EPASWorkshopSelectionState();
}

class _EPASWorkshopSelectionState extends State<EPASWorkshopSelection> {
  void goBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onWidgetBuild();
    });
  }

  void onWidgetBuild() {
    loadWorkShops();
  }

  void loadWorkShops() async {
    final ExtensionManager extensionManager =
        StoreProvider.of<AppState>(context).state.extensionManager;
    final EPASApi epasApi = extensionManager.getExtensions("EPAS");
    epasApi.loading = true;
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
    await epasApi.loadWorkshops(widget.timetableId);
    StoreProvider.of<AppState>(context).dispatch(extensionManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: StoreConnector<AppState, ExtensionManager>(
          converter: (store) => store.state.extensionManager,
          builder: (context, extensionManager) {
            final EPASApi epasApi = extensionManager.getExtensions("EPAS");
            final EPASTimetable timetable = epasApi.timetables.firstWhere(
                (timetable) => timetable.id == widget.timetableId,
                orElse: () => null);
            return Column(
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "IZBIRA DELAVNICE (${timetable?.getStartHour() ?? ""})",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Positioned(child: BackButton(onPressed: goBack))
                  ],
                ),
                !epasApi.loading
                    ? EPASWorkshopSelectionList(
                        epasApi.workshops, widget.timetableId, context)
                    : loadingItem(EPASStyle.backgroundColor)
              ],
            );
          }),
    ));
  }
}
