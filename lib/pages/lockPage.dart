import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/nastavitve/lockPage/unlockButton.dart';
import 'package:scv_app/global/global.dart' as global;

import '../api/biometric.dart';
import '../store/AppState.dart';

class LockPage extends StatefulWidget {
  @override
  _LockPageState createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authenticate();
    });
  }

  Future<void> logout() async {
    Navigator.pop(context);
    await global.logOutUser(context);
  }

  Future<void> authenticate() async {
    setState(() {
      loading = true;
    });
    final Biometric biometric =
        StoreProvider.of<AppState>(context).state.biometric;
    await biometric.unlock(context,
        text:
            "V telefonu nimaš nastavljenih varnostnih nastavitev. Zato vam nemoremo odkleniti aplikacije.",
        actions: [
          TextButton(
              onPressed: logout,
              child: Text(
                "Odjava",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ]);
    StoreProvider.of<AppState>(context).dispatch(biometric);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9), //add border radius
            child: Image.asset(
              "assets/images/1024.png",
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 25)),
          Text(
            "Prijava v sistem ŠCVApp",
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.27)),
          !loading
              ? unlockButton(context, authenticate)
              : CircularProgressIndicator(),
        ],
      ),
    )));
  }
}
