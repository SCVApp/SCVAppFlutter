import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/epas/EPAS.dart';
import 'package:scv_app/api/epas/EPASUserListItem.dart';
import 'package:scv_app/api/epas/timetable.dart';
import 'package:scv_app/api/epas/workshop.dart';
import 'package:scv_app/components/EPAS/adminWorkshopJoinList/listItem.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/manager/extensionManager.dart';
import 'package:http/http.dart' as http;
import 'package:scv_app/global/global.dart' as global;
import 'package:scv_app/pages/EPAS/style.dart';

import '../../store/AppState.dart';

class EPASAdminWorkshopJoinList extends StatefulWidget {
  EPASAdminWorkshopJoinList(this.workshopId, {Key key}) : super(key: key);
  final int workshopId;
  @override
  _EPASAdminWorkshopJoinListState createState() =>
      _EPASAdminWorkshopJoinListState();
}

class _EPASAdminWorkshopJoinListState extends State<EPASAdminWorkshopJoinList> {
  List<EPASUserListItem> users = [];
  bool loading = false;

  void loadList() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http.get(
          Uri.parse(
              "${EPASApi.EPASapiUrl}/user/myworkshop/${widget.workshopId}/joinlist"),
          headers: {"Authorization": "${global.token.accessToken}"});
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        print(json);
        setState(() {
          this.users = json.map((e) => EPASUserListItem.fromJson(e)).toList();
        });
      }
    } catch (e) {}
    final promises = <Future>[];
    print(users);
    for (EPASUserListItem user in this.users) {
      promises.add(user.getUsername());
    }
    await Future.wait(promises);
    setState(() {
      this.users = this.users;
      this.loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: StoreConnector<AppState, ExtensionManager>(
      converter: (store) => store.state.extensionManager,
      builder: (context, extensionManager) {
        final EPASApi epasApi = extensionManager.getExtensions("EPAS");
        final EPASWorkshop workshop = epasApi.workshops.firstWhere(
            (element) => element.id == widget.workshopId,
            orElse: () => null);
        final EPASTimetable timetable = epasApi.timetables.firstWhere(
            (timetable) => timetable.id == workshop?.timetable_id,
            orElse: () => null);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButton(
              onPressed: () => Navigator.pop(context),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                  "Prijavljeni dijaki na delavnico ${workshop?.name ?? ""} ob ${timetable?.getStartHour() ?? ""}")
            ]),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            !loading
                ? Expanded(
                    child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return EPASAdminWorkshopJoinListItem(users[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                  ))
                : loadingItem(EPASStyle.backgroundColor)
          ],
        );
      },
    )));
  }
}
