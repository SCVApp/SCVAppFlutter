import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/components/otherStyleBox.dart';
import 'package:scv_app/UrnikPages/detailUrnik.dart';
import 'package:scv_app/UrnikPages/mainUrnik.dart';
import 'package:scv_app/UrnikPages/urnikData.dart';
import 'package:scv_app/data.dart';

class SomeValuseForSize {
  final double height;
  final double primaryFontSize;
  final double secundaryFontSize;
  final double widthOfIcon;
  SomeValuseForSize(
      {this.height,
      this.primaryFontSize,
      this.secundaryFontSize,
      this.widthOfIcon});
}

final defualtStyleBox = new UrnikBoxStyle(
    bgColor: Colors.blue,
    primaryTextColor: Colors.white,
    secundaryTextColor: Colors.white);

Widget HourBoxUrnik(
    {bool isSmall = false,
    UrnikBoxStyle urnikBoxStyle,
    UraTrajanje trajanjeUra,
    BuildContext context,
    String mainTitle = "",
    UrnikData urnikData}) {
  String krajsava = "";
  String ucilnica = "";
  int id = 0; // Katera ura po vrsti je npr. 1., 0., 5. ...
  String trajanje = "";
  int izbranaUra = 0; // Katera ura jeizbrana v istem casovnem obdobju
  String ucitelj = "";

  final SomeValuseForSize someValuesForSize = !isSmall
      ? SomeValuseForSize(
          height: 90,
          primaryFontSize: 24,
          secundaryFontSize: 15,
          widthOfIcon: 30)
      : SomeValuseForSize(
          height: 60,
          primaryFontSize: 20,
          secundaryFontSize: 13,
          widthOfIcon: 30);

  if (trajanjeUra != null && trajanjeUra.ura.length > 0) {
    Ura ura = trajanjeUra.ura[izbranaUra];
    krajsava = ura.krajsava != "" ? ura.krajsava : "";
    ucilnica = ura.ucilnica != "" ? ura.ucilnica : "/   ";
    id = trajanjeUra.id;
    trajanje = trajanjeUra.trajanje;
    ucitelj = ura.ucitelj;

    if (ura.nadomescanje == true ||
        ura.dogodek != "" ||
        ura.odpadlo == true ||
        ura.zaposlitev == true) {
      OtherStyleBox styleOfBox = OtherStyleBox.odpadlo;
      if (ura.dogodek != "") {
        styleOfBox = OtherStyleBox.dogodek;
      } else if (ura.nadomescanje == true) {
        styleOfBox = OtherStyleBox.nadomescanje;
      } else if (ura.odpadlo == true) {
        styleOfBox = OtherStyleBox.odpadlo;
      } else if (ura.zaposlitev == true) {
        styleOfBox = OtherStyleBox.zaposlitev;
      }
      return GestureDetector(
        child: otherStyleBox(someValuesForSize, context, id, krajsava, trajanje,
            ucilnica, styleOfBox, ura.dogodek, urnikData),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailUrnik(context, urnikData,
                      trajanje: trajanje,
                      ucilnica: ucilnica,
                      id: id,
                      ucitelj: ucitelj,
                      krajsava: krajsava,
                      dogodek: ura.dogodek,
                      styleOfBox: styleOfBox)));
        },
      );
    }
  } else {
    krajsava = "/";
    ucilnica = "/";
    id = -1;
    trajanje = "/";
    ucitelj = "";
  }

  void prikaziPodrobnosti() {
    if (id >= 0 || krajsava != "/" || ucilnica != "/" || ucitelj != "") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailUrnik(
                context,
                urnikData,
                ucilnica: ucilnica,
                id: id,
                trajanje: trajanje,
                ucitelj: ucitelj,
                krajsava: krajsava,
              )));
    }
  }

  if (mainTitle != "") {
    return Container(
      height: someValuesForSize.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: urnikBoxStyle != null
            ? urnikBoxStyle == urnikData.otherStyle
                ? Theme.of(context).cardColor
                : urnikBoxStyle.bgColor
            : Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$mainTitle",
            style: TextStyle(
                fontSize: 20,
                color: urnikBoxStyle != null
                    ? urnikBoxStyle.primaryTextColor
                    : Colors.white,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  return GestureDetector(
      child: Container(
        height: someValuesForSize.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: urnikBoxStyle != null
              ? urnikBoxStyle == urnikData.otherStyle
                  ? Theme.of(context).cardColor
                  : urnikBoxStyle.bgColor
              : Colors.white,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "${id < 0 ? "" : id.toString() + ".${id < 10 ? " " : ""}"}",
                      style: TextStyle(
                          fontSize: someValuesForSize.primaryFontSize,
                          color: urnikBoxStyle != null
                              ? urnikBoxStyle != urnikData.nowStyle
                                  ? Theme.of(context).primaryColor
                                  : urnikBoxStyle.primaryTextColor
                              : Colors.white),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$krajsava",
                          style: TextStyle(
                              fontSize: someValuesForSize.secundaryFontSize,
                              color: urnikBoxStyle != null
                                  ? urnikBoxStyle != urnikData.nowStyle
                                      ? Theme.of(context).primaryColor
                                      : urnikBoxStyle.primaryTextColor
                                  : Colors.white),
                        ),
                        Text(
                          "$trajanje",
                          style: TextStyle(
                              fontSize: someValuesForSize.secundaryFontSize,
                              color: urnikBoxStyle != null
                                  ? urnikBoxStyle.secundaryTextColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  "$ucilnica",
                  style: TextStyle(
                      fontSize: someValuesForSize.primaryFontSize,
                      color: urnikBoxStyle != null
                          ? urnikBoxStyle != urnikData.nowStyle
                              ? Theme.of(context).primaryColor
                              : urnikBoxStyle.primaryTextColor
                          : Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
            ]),
      ),
      onTap: prikaziPodrobnosti);
}
