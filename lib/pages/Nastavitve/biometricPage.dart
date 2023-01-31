import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/components/nastavitve/biomatricPage/autoLockPicekr.dart';

import '../../components/backButton.dart';
import '../../store/AppState.dart';

class BiometicPage extends StatefulWidget {
  @override
  _BiometicPageState createState() => _BiometicPageState();
}

class _BiometicPageState extends State<BiometicPage> {
  void handleChangeAutoLock(Picker picker, List<int> list) async {
    final Biometric biometric =
        StoreProvider.of<AppState>(context).state.biometric;
    await biometric.setAutoLockMode(list[0]);
    StoreProvider.of<AppState>(context).dispatch(biometric);
  }

  void handleChangeBiometricUnlock(bool value) async {
    final Biometric biometric =
        StoreProvider.of<AppState>(context).state.biometric;
    if (biometric.locked == true) {
      return;
    }
    final String text =
        "V telefonu nimaš nastavljenih varnostnih nastavitev, zato vam nemoremo spremeniti nastavitve biometričnega odklepanja.";
    if (await biometric.authenticate(context, text: text) == true) {
      await biometric.setBiometric(value);
      StoreProvider.of<AppState>(context).dispatch(biometric);
    } else {
      await biometric.setBiometric(false);
      StoreProvider.of<AppState>(context).dispatch(biometric);
    }
  }

  @override
  Widget build(BuildContext context) {
    double textSize = min(MediaQuery.of(context).size.width * 0.042, 16);
    TextStyle textStyle = TextStyle(
      fontSize: textSize,
      color: Theme.of(context).primaryColor,
    );

    return StoreConnector<AppState, Biometric>(
        converter: (store) => store.state.biometric,
        builder: (context, biometric) {
          return Scaffold(
              body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                backButton(context),
                Padding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Biometrični odklep aplikacije",
                              style: textStyle),
                          SizedBox(
                            child: CupertinoSwitch(
                              value: biometric.biometric,
                              onChanged: handleChangeBiometricUnlock,
                            ),
                            width: 45,
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      biometric.biometric
                          ? GestureDetector(
                              child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "Zaklep aplikacije v ozadju po:",
                                      style: textStyle,
                                    ),
                                    Text(
                                      Biometric
                                          .autoLockModes[biometric.autoLockMode]
                                          .toString(),
                                      style: textStyle,
                                    )
                                  ]),
                              onTap: () {
                                autoLockPicker(
                                    context, handleChangeAutoLock, biometric);
                              })
                          : SizedBox(),
                      Padding(padding: EdgeInsets.only(top: 60)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("INFO",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: textSize,
                                  fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          Text(
                            "Z omogočanjem te nastavitve lahko nato v aplikacijo vstopiš preko biometričnih podatkov (prepoznava obraza ali Face ID, prepoznava prstnega odtisa ali Touch ID ter PIN ali geslo telefona). V primeru, da na telefonu nimaš nič od navedenega, te aplikacija opozori, da dodaš vsaj en varnostni pogoj, naveden zgoraj.",
                            style: textStyle,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )
                    ],
                  ),
                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                )
              ],
            ),
          ));
        });
  }
}
