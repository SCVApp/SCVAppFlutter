import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({Key key, this.color}) : super(key: key);
  Color color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: color),
      ),
    );
  }
}
