import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/locker.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:scv_app/api/lockers/results/endLocker.result.dart';
import 'package:scv_app/api/lockers/results/openLocker.result.dart';
import 'package:scv_app/components/lockers/lockerView.dart';
import 'package:scv_app/components/lockers/notLockerView.dart';

class LockerControllerPage extends StatefulWidget {
  LockerControllerPage({required this.controller}) : super();
  final LockerController controller;

  @override
  _LockerControllerPageState createState() => _LockerControllerPageState();
}

class _LockerControllerPageState extends State<LockerControllerPage> {
  Locker? myLocker;
  bool isLoading = true;

  initState() {
    super.initState();
    loadMyLocker();
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.message)));
    }
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.controller.name),
        ),
        body: isLoading
            ? Text("loading")
            : myLocker == null
                ? NotLockerView(context, openLocker)
                : LockerView(context, myLocker!, openLocker, endLocker));
  }
}
