import 'package:flutter/material.dart';
import 'package:scv_app/components/alertContainer.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({Key key, this.color}) : super(key: key);
  Color color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: AlertContainer(),
      body: Center(
        child: CircularProgressIndicator(color: color),
      ),
    );
  }
}
