import 'package:flutter/material.dart';
import 'package:scv_app/api/lockers/lockerController.dart';
import 'package:scv_app/components/lockers/lockerControllerTile.dart';
import 'package:scv_app/pages/Lockers/controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void showControllerPage(LockerController controller) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => LockerControllerPage(controller: controller),
      ),
    );
  }

  Future<void> loadControllers() async {
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
          title: Text(AppLocalizations.of(context)!.lockers),
        ),
        body: RefreshIndicator(
          onRefresh: loadControllers,
          child: ListView.builder(
            itemCount: controllers.length,
            itemBuilder: (context, index) {
              LockerController controller = controllers[index];
              return LockerControllerTile(context, controller,
                  onTap: () => showControllerPage(controller));
            },
          ),
        ));
  }
}
