import 'package:flutter/material.dart';
import '../extension/hexColor.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    //Zamenjaj barve za svtlo temo
    backgroundColor: Colors.white, //Barva upper menu bar
    primaryColor: Colors.black, //Barva za text
    scaffoldBackgroundColor: Colors.white, //Tema za ozadje v nastavitvah
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.white, //Barva za spodnji menu bar
    ),
    cardColor: HexColor.fromHex("#FAFAFA"), //Barva oblački
    hintColor: Colors.white, //Barva za ikone v oblčkih
    shadowColor: Colors.grey.withOpacity(0.5), //Barva senc
  );
  static final dark = ThemeData.dark().copyWith(
    //Zamenjaj barve za temno temo
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: HexColor.fromHex("#121212"),
    primaryColor: Colors.white,
    bottomAppBarTheme: BottomAppBarTheme(
      color: HexColor.fromHex("#1C1C1E"), //Barva za spodnji menu bar
    ),
    cardColor: HexColor.fromHex("#1C1C1E"),
    hintColor: HexColor.fromHex("#1C1C1E"),
    shadowColor: Color.fromARGB(255, 32, 32, 32).withOpacity(0),
  );
}
