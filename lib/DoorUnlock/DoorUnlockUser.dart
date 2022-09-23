import 'package:flutter/material.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Data/functions.dart';
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
            child: Column(
      children: [
        backButton(context),
        Padding(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
              ].withSpaceBetween(spacing: 30)),
          padding: EdgeInsets.symmetric(horizontal: 40),
        )
      ],
    )));
  }
}
