import 'package:flutter/material.dart';

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
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Padding(
                child: Text("Trenutno na urniku"),
                padding:
                    EdgeInsets.only(bottom: this.gap, left: 15, right: 15)),
          ],
        ),
      ),
    );
  }
}
