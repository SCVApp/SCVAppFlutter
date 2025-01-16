import 'package:flutter/material.dart';

class LockerControllerPage extends StatefulWidget {
  @override
  _LockerControllerPageState createState() => _LockerControllerPageState();
}

class _LockerControllerPageState extends State<LockerControllerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("C500 omarice"),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Trenutno nimaš izbrane omarice",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center),
          TextButton(
            onPressed: () {},
            child: Text("Dodeli mi omarico",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ]));
  }
}
