import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/confirmAlert.dart';
import 'package:scv_app/components/nastavitve/lockPage/unlockButton.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void confirmLogout() async {
    confirmAlert(context, AppLocalizations.of(context)!.prompt_logout, logout,
        () => Navigator.pop(context));
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
            (AppLocalizations.of(context)!.no_biometrics_when_unlock),
        actions: [
          TextButton(
              onPressed: confirmLogout,
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
            (AppLocalizations.of(context)!.login_scvapp),
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
