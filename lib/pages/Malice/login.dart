import 'package:flutter/material.dart';

class MaliceLoginPage extends StatefulWidget {
  @override
  _MaliceLoginPageState createState() => _MaliceLoginPageState();
}

class _MaliceLoginPageState extends State<MaliceLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Text('Malice Login Page'),
      ),
    );
  }
}