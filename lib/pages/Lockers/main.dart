import 'package:flutter/material.dart';
import 'package:scv_app/components/lockers/lockerControllerTile.dart';
import 'package:scv_app/pages/Lockers/controller.dart';

class LockerPage extends StatefulWidget {
  @override
  _LockerPageState createState() => _LockerPageState();
}

class _LockerPageState extends State<LockerPage> {
  void showControllerPage() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => LockerControllerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Omarice"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return LockerControllerTile(showControllerPage);
        },
      ),
    );
  }
}
