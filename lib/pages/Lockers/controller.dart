import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:scv_app/components/lockers/lockedLocker.dart';
import 'package:scv_app/components/lockers/lockerSlidable.dart';
import 'package:scv_app/pages/Lockers/lockers.dart';
import 'package:scv_app/pages/loading.dart';

class LockerControllerPage extends StatefulWidget {
  LockerControllerPage({required this.controller}) : super();
  final LockerController controller;

  @override
  _LockerControllerPageState createState() => _LockerControllerPageState();
}

class _LockerControllerPageState extends State<LockerControllerPage> {
  Locker? myLocker;
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
    Locker? fetchedLocker = await Locker.fetchMyLocker();
    setState(() {
      isLoading = false;
      myLocker = fetchedLocker;
    });
  }

  void refresh() {
    loadMyLocker();
    loadLockersFromController();
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
    return ListView.builder(
      itemCount: lockers!.length,
      itemBuilder: (context, index) {
        final Locker locker = lockers![index];
        final bool isUsers = myLocker != null &&
            myLocker!.id == locker.id; //Check if this is users locker
        final bool disabled = myLocker != null &&
            myLocker!.id !=
                locker.id; //If user has a locker, disable all other lockers
        return locker.used && !isUsers
            ? LockedLocker(locker)
            : LockerSlidable(
                locker: locker,
                isUsers: isUsers,
                refresh: refresh,
                disabled: disabled);
      },
    );
  }
}
