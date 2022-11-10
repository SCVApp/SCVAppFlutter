import 'package:flutter/material.dart';
import 'package:scv_app/Data/data.dart';

import '../detailUrnik.dart';
import 'boxForHour.dart';

enum OtherStyleBox { normalno, odpadlo, nadomescanje, zaposlitev, dogodek }

var colorsForStyles = {
  OtherStyleBox.odpadlo: HexColor.fromHex("#FFB9AE"),
  OtherStyleBox.nadomescanje: HexColor.fromHex("#ABE8F9"),
  OtherStyleBox.zaposlitev: HexColor.fromHex("#FFB0F7"),
  OtherStyleBox.dogodek: HexColor.fromHex("#FFE2AC")
};
var textColorsForStyle = {
  OtherStyleBox.odpadlo: Colors.black,
  OtherStyleBox.nadomescanje: Colors.black,
  OtherStyleBox.zaposlitev: Colors.black,
  OtherStyleBox.dogodek: Colors.black
};
var imagesForStyle = {
  OtherStyleBox.odpadlo: "assets/urnikIcons/odpadlo.png",
  OtherStyleBox.nadomescanje: "assets/urnikIcons/nadomescanje.png",
  OtherStyleBox.zaposlitev: "assets/urnikIcons/zaposlitev.png",
  OtherStyleBox.dogodek: "assets/urnikIcons/dogodek.png"
};

Widget otherStyleBox(
    SomeValuseForSize someValuesForSize,
    BuildContext context,
    int id,
    String krajsava,
    String trajanje,
    String ucilnica,
    OtherStyleBox styleOfBox,
    String dogodek,
    UrnikData urnikData) {
  return Container(
      height: someValuesForSize.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorsForStyles[styleOfBox],
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 3,
            offset: Offset(4, 4), // Shadow position
          ),
        ],
      ),
      child: Stack(children: [
        Row(
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
                          color: textColorsForStyle[styleOfBox]),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Text(
                              "${styleOfBox != OtherStyleBox.dogodek ? krajsava : dogodek}",
                              style: TextStyle(
                                  fontSize: someValuesForSize.secundaryFontSize,
                                  color: textColorsForStyle[styleOfBox],
                                  overflow: TextOverflow.ellipsis,
                                  decoration:
                                      OtherStyleBox.odpadlo == styleOfBox
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                              maxLines: 1,
                              softWrap: false,
                            )),
                        Text(
                          "$trajanje",
                          style: TextStyle(
                              fontSize: someValuesForSize.secundaryFontSize,
                              color: textColorsForStyle[styleOfBox]),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              styleOfBox != OtherStyleBox.dogodek
                  ? Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        "$ucilnica",
                        style: TextStyle(
                            fontSize: someValuesForSize.primaryFontSize,
                            color: textColorsForStyle[styleOfBox],
                            decoration: OtherStyleBox.odpadlo == styleOfBox
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                        textAlign: TextAlign.right,
                      ),
                    )
                  : SizedBox()
            ]),
        Positioned(
          child: Image.asset(
            imagesForStyle[styleOfBox],
            width: someValuesForSize.widthOfIcon,
            height: someValuesForSize.widthOfIcon,
          ),
          right: 0,
          top: -2,
        ),
      ]));
}
