import 'dart:math';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/components/loadingItem.dart';
import 'package:scv_app/components/nastavitve/logOutPopUp.dart';
import 'package:scv_app/components/nastavitve/nastavitveGroup.dart';
import 'package:scv_app/components/nastavitve/settingsUserCard.dart';
import 'package:scv_app/store/AppState.dart';
import 'package:get/get.dart';

import '../../api/user.dart';
import '../../extension/hexColor.dart';

class NastavitvePage extends StatefulWidget {
  @override
  _NastavitvePageState createState() => _NastavitvePageState();
}

class _NastavitvePageState extends State<NastavitvePage> {
  void odjava() {
    logOutPopup(context);
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
                          onTap: (() {}),
                        )
                      : loadingItem(user.school.schoolColor),
                  SettingsItem(
                    icons: Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                      withBackground: true,
                      backgroundColor: HexColor.fromHex("#EE5BA0"),
                    ),
                    title: 'Videz aplikacije',
                    onTap: () {},
                  ),
                  SettingsItem(
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                      withBackground: true,
                      backgroundColor: HexColor.fromHex("#FFCA05"),
                    ),
                    title: 'Biometrično odklepanje',
                    onTap: () {},
                  ),
                  SettingsItem(
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                      backgroundColor: HexColor.fromHex("#8DD7F7"),
                    ),
                    title: 'O aplikaciji',
                    subtitle: "Podatki o aplikaciji",
                    onTap: () {},
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
