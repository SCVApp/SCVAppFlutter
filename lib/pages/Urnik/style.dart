import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/api/school.dart';
import 'package:scv_app/api/urnik/ura.dart';
import 'package:scv_app/api/urnik/urnik.dart';
import 'package:scv_app/extension/hexColor.dart';
import 'package:scv_app/store/AppState.dart';

import '../../api/urnik/obdobjaUr.dart';

class UrnikStyle {
  static final viewStyleBig = ViewSizes(90, 24, 15, 30, Size.square(9.0));
  static final viewStyleSmall = ViewSizes(60, 20, 13, 20, Size.square(7.0));

  static String mainTitle(PoukType type) {
    switch (type) {
      case PoukType.zacetekPouka:
        return "začetek pouka";
      case PoukType.pouk:
        return "naslednje ure";
      case PoukType.odmor:
        return "naslednje ure";
    }
  }

  static String pathToIcon(UraType uraType) {
    switch (uraType) {
      case UraType.dogodek:
        return "assets/images/urnikIcons/dogodek.png";
      case UraType.nadomescanje:
        return "assets/images/urnikIcons/nadomescanje.png";
      case UraType.odpadlo:
        return "assets/images/urnikIcons/odpadlo.png";
      case UraType.zaposlitev:
        return "assets/images/urnikIcons/zaposlitev.png";
    }
  }

  static Color colorForUraViewBG(UraType uraType, ObdobjaUrType obdobjaUrType,
      BuildContext context, School school) {
    switch (uraType) {
      case UraType.dogodek:
        return HexColor.fromHex("#FFE2AC");
      case UraType.nadomescanje:
        return HexColor.fromHex("#ABE8F9");
      case UraType.odpadlo:
        return HexColor.fromHex("#FFB9AE");
      case UraType.zaposlitev:
        return HexColor.fromHex("#FFB0F7");
    }
    switch (obdobjaUrType) {
      case ObdobjaUrType.trenutno:
        return school.schoolColor;
      case ObdobjaUrType.naslednje:
        return school.schoolSecondaryColor;
    }
    return Theme.of(context).cardColor;
  }

  static Color colorForUraViewText(UraType uraType, BuildContext context) {
    switch (uraType) {
      case UraType.dogodek:
        return Colors.black;
      case UraType.nadomescanje:
        return Colors.black;
      case UraType.odpadlo:
        return Colors.black;
      case UraType.zaposlitev:
        return Colors.black;
    }
    return Theme.of(context).primaryColor;
  }

  static Widget mainTitleForBox() {
    return StoreConnector<AppState, Urnik>(
      converter: (store) => store.state.urnik,
      builder: (context, urnik) {
        String text = "";
        if (urnik.poukType == PoukType.konecPouka) {
          text = "Konec pouka";
        } else if (urnik.poukType == PoukType.odmor) {
          text = "Odmor do ${urnik.zacetekNaslednjegaObdobja()}";
        } else if (urnik.poukType == PoukType.zacetekPouka) {
          text = "Začetek pouka ob ${urnik.zacetekNaslednjegaObdobja()}";
        } else if (urnik.poukType == PoukType.niPouka) {
          text = "Ni pouka";
        }

        return Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}

class ViewSizes {
  final double height;
  final double primaryFontSize;
  final double secundaryFontSize;
  final double widthOfIcon;
  final Size sizeOfDots;

  ViewSizes(this.height, this.primaryFontSize, this.secundaryFontSize,
      this.widthOfIcon, this.sizeOfDots);
}
