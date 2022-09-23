import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/DoorUnlock/DoorUnlockUser.dart';
import 'package:scv_app/DoorUnlock/components/DoorCardWidget.dart';
import 'package:scv_app/DoorUnlock/components/DoorCardsWidget.dart';
import '../Data/data.dart';


class DoorUnlockPage extends StatefulWidget {
  DoorUnlockPage({Key key, this.data}) : super(key: key);

  final Data data;

  _DoorUnlockPage createState() => _DoorUnlockPage();
}

class _DoorUnlockPage extends State<DoorUnlockPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        backButton(context),
        DoorCardsWidget(),
        Text("Test"),
        //button go to another page
        TextButton(
          child: Text("Odkleni vrata"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoorUnlockUserPage()),
            );
          },
        ),
      
      ],
    )));
  }
}
