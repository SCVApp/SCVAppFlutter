import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:scv_app/api/lockers/results/lockerWithActiveUser.result.dart';
import 'package:scv_app/components/lockers/lockerTile.dart';

class LockersPage extends StatefulWidget {
  LockersPage({required this.lockers, required this.controller}) : super();
  final List<LockerWithActiveUserResult> lockers;
  final LockerController controller;

  @override
  _LockersPageState createState() => _LockersPageState();
}

class _LockersPageState extends State<LockersPage> {
  List<LockerWithActiveUserResult>? lockers;

  initState() {
    super.initState();
    setState(() {
      this.lockers = widget.lockers;
    });
  }

  void loadLockersFromController() async {
    List<LockerWithActiveUserResult>? lockers =
        await widget.controller.fetchLockersWithActiveUsers();
    setState(() {
      this.lockers = lockers;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Omarice"),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: loadLockersFromController,
            ),
          ],
        ),
        body: SafeArea(
          child: this.lockers == null
              ? Icon(Icons.error)
              : ListView.builder(
                  itemCount: this.lockers!.length,
                  itemBuilder: (context, index) {
                    LockerWithActiveUserResult locker = lockers![index];
                    return LockerTile(
                        context, locker, loadLockersFromController);
                  },
                ),
        ));
  }
}
