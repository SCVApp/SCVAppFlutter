import 'package:flutter/material.dart';
import 'package:scv_app/components/urnik/mainTitle.dart';
import 'package:scv_app/components/urnik/seeOtherDays.dart';

class UrnikPage extends StatefulWidget {
  @override
  _UrnikPageState createState() => _UrnikPageState();
}

class _UrnikPageState extends State<UrnikPage> {
  final double gap = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Padding(
                child: mainTitle(),
                padding:
                    EdgeInsets.only(bottom: this.gap, left: 15, right: 15)),
            seeOtherDays(gap, context),
            Padding(
              child: Align(
                child: Text(
                  "Današnji urnik",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.centerLeft,
              ),
              padding:
                  EdgeInsets.only(bottom: this.gap * 2, left: 15, right: 15),
            ),
          ],
        )),
      ),
    );
  }
}
