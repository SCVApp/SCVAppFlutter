import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(//Zamenjaj barve za svtlo temo
    backgroundColor: Colors.white,//Barva upper menu bar
    primaryColor: Colors.black,//Color text
    bottomAppBarColor: Colors.white,//Menu bar spodnji
    cardColor: Colors.white,//Barva oblački
  );
  static final dark = ThemeData.dark().copyWith(//Zamenjaj barve za tmno temo
    backgroundColor: Colors.black,
    primaryColor: Colors.white,
    bottomAppBarColor: Color.fromARGB(255, 80, 79, 79),
    cardColor: Color.fromARGB(255, 80, 79, 79),
  );
}