import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/DoorUnlock/components/DoorCardWidget.dart';
import 'package:scv_app/DoorUnlock/components/DoorCardsWidget.dart';
import '../Data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoorUnlockUserPage extends StatefulWidget {
  DoorUnlockUserPage({Key key, this.data}) : super(key: key);

  final Data data;

  _DoorUnlockUserPage createState() => _DoorUnlockUserPage();
}

class _DoorUnlockUserPage extends State<DoorUnlockUserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Wrap(
      spacing: 20,
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      children: [
        backButton(context),
        Container(
          height: (MediaQuery.of(context).size.width * 0.5) + 40,
          //add svg asset image
          child: SvgPicture.asset(
            'assets/Door_Closed.svg',
            color: Colors.green,
            height: (MediaQuery.of(context).size.width * 0.5) + 20,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Izbrana učilnica:"),
            Text("C503"),
          ],
        ),
        //button with lock icon and text Odlkleni vrata
        FloatingActionButton.extended(
          onPressed: () {},
          icon: Icon(
            Icons.lock,
            size: 23,
          ),
          label: const Text("Odkleni vrata"),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        Container(
          child: Text("Vrata uspešno odklenjena!"),
        ),
      ],
    )));
  }
}
