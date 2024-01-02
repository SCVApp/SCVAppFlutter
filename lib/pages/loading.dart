import 'package:flutter/material.dart';
import 'package:scv_app/components/alertContainer.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({Key? key, this.color = Colors.blue}) : super(key: key);
  final Color color;
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
