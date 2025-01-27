import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/components/lockers/lockerBox.dart';
import 'package:scv_app/pages/Lockers/lockers.dart';
import 'package:scv_app/pages/loading.dart';

class LockerControllerPage extends StatefulWidget {
  LockerControllerPage({required this.controller}) : super();
  final LockerController controller;

  @override
  _LockerControllerPageState createState() => _LockerControllerPageState();
}

class _LockerControllerPageState extends State<LockerControllerPage> {
  List<Locker> myLockers = [];
  List<LockerWithActiveUserResult>? lockersAdmin;
  List<Locker>? lockers;
  bool isLoading = true;

  initState() {
    super.initState();
    loadMyLocker();
    loadLockersFromController();
    loadLockersFromControllerAdmin();
  }

  void loadLockersFromControllerAdmin() async {
    List<LockerWithActiveUserResult>? lockers =
        await widget.controller.fetchLockersWithActiveUsers();
    setState(() {
      this.lockersAdmin = lockers;
    });
  }

  void loadLockersFromController() async {
    List<Locker>? lockers = await widget.controller.fetchLockers();
    setState(() {
      this.lockers = lockers;
    });
  }

  void goToLockers() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LockersPage(
                lockers: this.lockersAdmin!, controller: widget.controller)));
  }

  void loadMyLocker() async {
    List<Locker> fetchedLockers = await Locker.fetchMyLockers();
    setState(() {
      isLoading = false;
      myLockers = fetchedLockers;
    });
  }

  void refresh() {
    loadMyLocker();
    loadLockersFromController();
  }

  bool isUsers(int lockerId) {
    for (Locker locker in myLockers) {
      if (locker.id == lockerId) {
        return true;
      }
    }
    return false;
  }

  bool isDisabled(int lockerId) {
    if (myLockers.length > 1) {
      return !isUsers(lockerId);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.controller.name), actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              refresh();
            },
          ),
          if (this.lockersAdmin != null)
            IconButton(
              icon: Icon(Icons.storage),
              onPressed: goToLockers,
            )
        ]),
        body: SafeArea(child: isLoading ? LoadingPage() : LockerList()));
  }

  Widget LockerList() {
    return GridView.count(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        padding: EdgeInsets.all(10),
        children: [
          if (lockers != null)
            for (Locker locker in lockers!)
              LockerBox(
                locker: locker,
                isUsers: isUsers(locker.id),
                disabled: isDisabled(locker.id),
                refresh: refresh,
              ),
          if (lockers == null) LoadingPage()
        ]);
  }
}
