import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/nastavitveGroup.dart';
import 'package:scv_app/Components/settingsUserCard.dart';
import 'package:scv_app/Nastavitve/aboutAplication.dart';
import 'package:scv_app/Nastavitve/aboutMe.dart';
import 'package:scv_app/Nastavitve/appAppearance.dart';
import 'package:scv_app/Nastavitve/biometricPage.dart';
import 'package:scv_app/Nastavitve/changeStatus.dart';
import 'package:scv_app/DoorUnlock/doorUnlockPage.dart';
import 'package:scv_app/Nastavitve/otherToolsPage.dart';
import 'package:scv_app/Data/functions.dart';
import 'package:scv_app/Intro_And__Login/prijava.dart';
import 'package:scv_app/api/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';

class NastavitvePage extends StatefulWidget {
  NastavitvePage({Key key, this.title, this.data, this.cacheData})
      : super(key: key);

  final String title;

  Data data;
  final CacheData cacheData;
  updateData(Data updateData) {
    data = updateData;
  }

  NastavitvePageState createState() => NastavitvePageState();
}

class NastavitvePageState extends State<NastavitvePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();
    loadToken();
    handleGetTheme();
  }

  bool jeSistemskaTema = false;
  bool isBioEnabled = false;
  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        token = prefs.getString(keyForAccessToken);
      });
    } catch (e) {
      print(e);
    }
    try {
      bool test = prefs.getBool(keyForUseBiometrics);
      if (test != null) {
        setState(() {
          isBioEnabled = test;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  ThemeEnum appTheme = ThemeEnum.light;

  Future<void> handleGetTheme() async {
    var t = await UseTheme.getTheme();

    setState(() {
      appTheme = t;
    });
  }

  void refreshBio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      try {
        bool test = prefs.getBool(keyForUseBiometrics);
        if (test != null) {
          setState(() {
            isBioEnabled = test;
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> odjava() async {
      Navigator.pop(context);
      await logOutUser(context);
    }

    void goToPageChangeStatus() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeStatusPage(
                data: widget.data,
                notifyParent: refresh,
              )));
    }

    void goToPageAboutApp() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AboutAppPage()));
    }

    void goToPageAboutMe() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AboutMePage(
                data: widget.data,
              )));
    }

    void goToPageAppAppearance() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppAppearance(
                onThemeChanged: handleGetTheme,
              )));
    }

    void goToPageBiometric() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BiometricPage(
                notifyParent: refreshBio,
              )));
    }

    void goToPageTools() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => OtherToolsPage()));
    }

    void goToDoorUnlock() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DoorUnlockPage()));
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Odjava'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    'Si prepričan, da se želiš odjaviti iz aplikacije ŠCVApp?',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Ne, prekliči'),
                  onPressed: () => Navigator.pop(context, 'Cancel')),
              TextButton(
                  child: const Text('Da, odjavi me.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: odjava),
            ],
          );
        },
      );
    }

    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              SettingsUserCard(
                userName: widget.data != null
                    ? widget.data.user.displayName
                    : widget.cacheData.userDisplayName,
                userProfilePic: widget.data != null
                    ? widget.data.user.image
                    : AssetImage("asstes/profilePicture.png"),
                cardColor: widget.data != null
                    ? widget.data.schoolData.schoolColor
                    : widget.cacheData.schoolColor,
                userMoreInfo: Text(
                    widget.data != null
                        ? widget.data.user.mail
                        : widget.cacheData.userMail,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: min(
                            MediaQuery.of(context).size.height / 42, 14.0))),
                data: widget.data,
              ),
              widget.data == null
                  ? Center(
                      child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: widget.cacheData.schoolColor,
                        ),
                        SettingsItem(
                          onTap: _showMyDialog,
                          icons: Icons.logout,
                          title: "Odjava",
                          subtitle: "Odjava iz aplikacije",
                          iconStyle: IconStyle(
                              iconsColor: Theme.of(context).hintColor,
                              withBackground: true,
                              backgroundColor: widget.cacheData.schoolColor ??
                                  Theme.of(context).backgroundColor //Barva šole
                              ),
                        )
                      ],
                    ))
                  : NastavitveGroup(
                      items: [
                        SettingsItem(
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            withBackground: true,
                            backgroundColor: HexColor.fromHex("#A6CE39"),
                          ),
                          icons: Icons.change_circle,
                          onTap: goToPageChangeStatus,
                          title: "Status",
                          subtitle: "Spremeni status",
                        ),
                        SettingsItem(
                          onTap: goToPageTools,
                          icons: Icons.construction,
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            backgroundColor: HexColor.fromHex("#0094d9"),
                          ),
                          title: 'Ostala orodja',
                          subtitle: "Orodja za šolo",
                        ),
                        SettingsItem(
                          onTap: goToPageAppAppearance,
                          icons: Get.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            withBackground: true,
                            backgroundColor: HexColor.fromHex("#EE5BA0"),
                          ),
                          title: 'Videz aplikacije',
                          subtitle: UseTheme.getNameOfTheme(appTheme),
                        ),
                        SettingsItem(
                          onTap: goToPageBiometric,
                          icons: Icons.fingerprint,
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            withBackground: true,
                            backgroundColor: HexColor.fromHex("#FFCA05"),
                          ),
                          title: 'Biometrično odklepanje',
                          subtitle: isBioEnabled ? "Vklopljeno" : "Izklopljeno",
                        ),
                        SettingsItem(
                          onTap: goToPageAboutApp,
                          icons: Icons.info_rounded,
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            backgroundColor: HexColor.fromHex("#8DD7F7"),
                          ),
                          title: 'O aplikaciji',
                          subtitle: "Podatki o aplikaciji",
                        ),
                      ],
                    ),
              widget.data == null
                  ? SizedBox()
                  : NastavitveGroup(
                      settingsGroupTitle: "Račun",
                      items: [
                        /* SettingsItem(
                          onTap: goToPageAboutMe,
                          icons: Icons.account_circle,
                          iconStyle: IconStyle(
                            iconsColor: Theme.of(context).hintColor,
                            backgroundColor: widget.data != null
                                ? widget.data.schoolData.schoolColor
                                : widget.cacheData.schoolColor,
                          ),
                          title: 'Moj račun',
                          subtitle: "Podatki mojega računa",
                        ), */
                        // SettingsItem(
                        //   onTap: goToDoorUnlock,
                        //   icons: Icons.door_back_door,
                        //   iconStyle: IconStyle(
                        //       iconsColor: Theme.of(context).hintColor,
                        //       withBackground: true,
                        //       backgroundColor: widget.data != null
                        //           ? widget.data.schoolData.schoolColor
                        //           : widget.cacheData.schoolColor //Barva šole
                        //       ),
                        //   title: 'Odklep vrat',
                        //   subtitle: "Odklep vrat s pomočjo QR kode",
                        // ),
                        SettingsItem(
                          onTap: _showMyDialog,
                          icons: Icons.logout,
                          title: "Odjava",
                          subtitle: "Odjava iz aplikacije",
                          iconStyle: IconStyle(
                              iconsColor: Theme.of(context).hintColor,
                              withBackground: true,
                              backgroundColor: widget.data != null
                                  ? widget.data.schoolData.schoolColor
                                  : widget.cacheData.schoolColor //Barva šole
                              ),
                        ),
                      ],
                    )
            ],
          ),
        ));
  }
}
