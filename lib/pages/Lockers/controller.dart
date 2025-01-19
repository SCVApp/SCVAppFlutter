import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:scv_app/components/lockers/lockerView.dart';
import 'package:scv_app/components/lockers/notLockerView.dart';
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
  List<LockerWithActiveUserResult>? lockers;
  bool isLoading = true;

  initState() {
    super.initState();
    loadMyLocker();
    loadLockersFromController();
  }

  void loadLockersFromController() async {
    List<LockerWithActiveUserResult>? lockers =
        await widget.controller.fetchLockersWithActiveUsers();
    setState(() {
      this.lockers = lockers;
    });
  }

  void goToLockers() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LockersPage(lockers: lockers!, controller: widget.controller)));
  }

  void loadMyLocker() async {
    Locker? fetchedLocker = await Locker.fetchMyLocker();
    setState(() {
      isLoading = false;
      myLocker = fetchedLocker;
    });
  }

  Future<void> openLocker() async {
    setState(() {
      isLoading = true;
    });
    OpenLockerResult result = await Locker.openLocker(widget.controller.id);
    if (result.success == true) {
      loadMyLocker();
    } else {
      setState(() {
        isLoading = false;
      });
    }
    if (result.message != null)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.message!),
          backgroundColor: result.success ? Colors.blueGrey : Colors.red));
  }

  Future<void> endLocker() async {
    setState(() {
      isLoading = true;
    });
    EndLockerResult result = await Locker.endLocker();
    if (result.success == true) {
      loadMyLocker();
    } else {
      setState(() {
        isLoading = false;
      });
    }
    if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.message!),
          backgroundColor: result.success ? Colors.blueGrey : Colors.red));
    }
    Navigator.pop(context);
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
              loadMyLocker();
            },
          ),
          if (lockers != null)
            IconButton(
              icon: Icon(Icons.storage),
              onPressed: goToLockers,
            )
        ]),
        body: SafeArea(
            child: isLoading
                ? LoadingPage()
                : myLocker == null
                    ? NotLockerView(context, openLocker)
                    : LockerView(context, myLocker!, openLocker, endLocker)));
  }
}
