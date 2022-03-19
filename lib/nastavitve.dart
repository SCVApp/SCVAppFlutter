import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

class NastavitvePage extends StatefulWidget {
  NastavitvePage({Key key, this.title, this.data}) : super(key: key);

  final String title;

  final Data data;

  _NastavitvePageState createState() => _NastavitvePageState();
}

class _NastavitvePageState extends State<NastavitvePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        token = prefs.getString(keyForAccessToken);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> odjava() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(keyForAccessToken);
      prefs.remove(keyForRefreshToken);
      prefs.remove(keyForExpiresOn);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }

    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              SimpleUserCard(
                userName: "Uporabnik",
                userProfilePic: NetworkImage(
                    "$apiUrl/user/get/profilePicture?=${widget.data.user.mail}",
                    headers: {"Authorization": token}),
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Status',
                    subtitle: "Spremeni svoj status!",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Temni način',
                    subtitle: "Avtomatsko",
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ],
                /* body: Center(
          child: Column(
            children: <Widget>[
              userInfo(odjava),
            ],
          ), */
              ),
            ],
          ),
        ));
  }

  Widget userInfo(odjava) {
    return new Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      userImage(),
      new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.data.user.displayName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Text(widget.data.user.mail)
        ],
      ),
      TextButton(
          onPressed: odjava,
          child: Image(
            image: AssetImage("assets/odjava.png"),
            height: 32,
          )),
    ]);
  }

  Widget userImage() {
    return token == ""
        ? Image(
            image: AssetImage("assets/profilePicture.png"),
            height: 100,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: FadeInImage(
              image: NetworkImage(
                  "$apiUrl/user/get/profilePicture?=${widget.data.user.mail}",
                  headers: {"Authorization": token}),
              placeholder: AssetImage("assets/profilePicture.png"),
              height: 100,
            ),
          );
  }
}
