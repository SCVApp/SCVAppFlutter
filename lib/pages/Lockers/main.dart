import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:scv_app/components/lockers/lockerControllerTile.dart';
import 'package:scv_app/pages/Lockers/controller.dart';

class LockerPage extends StatefulWidget {
  @override
  _LockerPageState createState() => _LockerPageState();
}

class _LockerPageState extends State<LockerPage> {
  List<LockerController> controllers = [];

  initState() {
    super.initState();
    loadControllers();
  }

  void showControllerPage() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => LockerControllerPage(),
      ),
    );
  }

  void loadControllers() async {
    List<LockerController> fetchedControllers =
        await LockerController.fetchControllers();
    setState(() {
      controllers = fetchedControllers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Omarice"),
      ),
      body: ListView.builder(
        itemCount: controllers.length,
        itemBuilder: (context, index) {
          LockerController controller = controllers[index];
          return LockerControllerTile(controller, onTap: showControllerPage);
        },
      ),
    );
  }
}
