import 'package:flutter/material.dart';
import 'package:scv_app/data.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    //Zamenjaj barve za svtlo temo
    backgroundColor: Colors.white, //Barva upper menu bar
    primaryColor: Colors.black, //Barva za text
    scaffoldBackgroundColor: Colors.white, //Tema za ozadje v nastavitvah
    bottomAppBarColor: Colors.white, //Menu bar spodnji
    cardColor: Color.fromARGB(255, 245, 244, 244), //Barva oblački
    hintColor: Colors.white, //Barva za ikone v oblčkih
  );
  static final dark = ThemeData.dark().copyWith(
    //Zamenjaj barve za temno temo
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: HexColor.fromHex("#121212"),
    primaryColor: Colors.white,
    bottomAppBarColor: HexColor.fromHex("#1C1C1E"),
    cardColor: HexColor.fromHex("#1C1C1E"),
    hintColor: HexColor.fromHex("#1C1C1E"),
  );
}
