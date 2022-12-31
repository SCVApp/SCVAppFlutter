import 'dart:math';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/appTheme.dart';
import 'package:scv_app/api/biometric.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/components/nastavitve/logOutPopUp.dart';
import 'package:scv_app/components/nastavitve/nastavitveGroup.dart';
import 'package:scv_app/components/nastavitve/settingsUserCard.dart';
import 'package:scv_app/pages/Nastavitve/appAppearance.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:get/get.dart';

import '../../api/user.dart';
import '../../extension/hexColor.dart';
import 'aboutApp.dart';
import 'biometricPage.dart';
import 'otherToolsPage.dart';

class NastavitvePage extends StatefulWidget {
  @override
  _NastavitvePageState createState() => _NastavitvePageState();
}

class _NastavitvePageState extends State<NastavitvePage> {
  void odjava() {
    logOutPopup(context);
  }

  void goToAppAppearance() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppAppearance()),
    );
  }

  void goToBiomericPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BiometicPage()),
    );
  }

  void goToOtherToolsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OtherToolsPage()),
    );
  }

  void goToAboutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutAppPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
              child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              SettingsUserCard(
                userName: user.displayName,
                userMoreInfo: Text(
                  user.mail,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          min(MediaQuery.of(context).size.height / 42, 14.0)),
                ),
                cardColor: user.school.schoolColor,
              ),
              NastavitveGroup(
                items: [
                  !user.loadingFromWeb
                      ? SettingsItem(
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            withBackground: true,
                            backgroundColor: HexColor.fromHex("#A6CE39"),
                          ),
                          icons: Icons.change_circle,
                          onTap: () {},
                          title: "Status",
                          subtitle: "Spremeni status",
                        )
                      : loadingItem(user.school.schoolColor),
                  !user.loadingFromWeb
                      ? SettingsItem(
                          icons: Icons.construction,
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            backgroundColor: HexColor.fromHex("#0094d9"),
                          ),
                          title: 'Ostala orodja',
                          subtitle: "Orodja za šolo",
                          onTap: goToOtherToolsPage,
                        )
                      : loadingItem(user.school.schoolColor),
                  StoreConnector<AppState, AppTheme>(
                      converter: (store) => store.state.appTheme,
                      builder: (context, appTheme) => SettingsItem(
                            icons: Get.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            iconStyle: IconStyle(
                              iconsColor: Theme.of(context).hintColor,
                              withBackground: true,
                              backgroundColor: HexColor.fromHex("#EE5BA0"),
                            ),
                            title: 'Videz aplikacije',
                            subtitle: appTheme.displayName() ?? "",
                            onTap: goToAppAppearance,
                          )),
                  StoreConnector<AppState, Biometric>(
                      converter: ((store) => store.state.biometric),
                      builder: (context, biometric) => SettingsItem(
                            icons: Icons.fingerprint,
                            iconStyle: IconStyle(
                              iconsColor: Theme.of(context).hintColor,
                              withBackground: true,
                              backgroundColor: HexColor.fromHex("#FFCA05"),
                            ),
                            title: 'Biometrično odklepanje',
                            subtitle: biometric.displayName() ?? "",
                            onTap: goToBiomericPage,
                          )),
                  SettingsItem(
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                      backgroundColor: HexColor.fromHex("#8DD7F7"),
                    ),
                    title: 'O aplikaciji',
                    subtitle: "Podatki o aplikaciji",
                    onTap: goToAboutPage,
                  ),
                ],
              ),
              NastavitveGroup(
                settingsGroupTitle: "Račun",
                items: [
                  SettingsItem(
                    onTap: odjava,
                    icons: Icons.logout,
                    title: "Odjava",
                    subtitle: "Odjava iz aplikacije",
                    iconStyle: IconStyle(
                        iconsColor: Theme.of(context).hintColor,
                        withBackground: true,
                        backgroundColor: user.school.schoolColor //Barva šole
                        ),
                  ),
                ],
              )
            ],
          )),
        );
      },
    );
  }
}
