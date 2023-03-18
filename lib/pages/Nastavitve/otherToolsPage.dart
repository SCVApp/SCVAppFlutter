import 'package:flutter/material.dart';
import 'package:scv_app/components/alertContainer.dart';
import '../../components/backButton.dart';

class OtherToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: AlertContainer(),
        body: SafeArea(
            child: Column(
          children: [
            backButton(context),
            Container(
                width: 200,
                height: 300,
                child: Image.asset(
                  'assets/images/Construction2.png',
                )),
            Text("Kmalu na voljo."),
          ],
        )));
  }
}
