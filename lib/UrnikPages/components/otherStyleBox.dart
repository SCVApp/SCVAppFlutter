import 'package:flutter/material.dart';
import 'package:scv_app/data.dart';

import 'boxForHour.dart';

enum OtherStyleBox{
  odpadlo,
  nadomescanje,
  zaposlitev,
  dogodek
}

Widget otherStyleBox(SomeValuseForSize someValuesForSize, BuildContext context, int id, String krajsava, String trajanje, String ucilnica, OtherStyleBox styleOfBox, String dogodek){
  var colorsForStyles = {
    OtherStyleBox.odpadlo: HexColor.fromHex("#BE3B26"),
    OtherStyleBox.nadomescanje: HexColor.fromHex("#1DB1DB"),
    OtherStyleBox.zaposlitev: HexColor.fromHex("#D42BC2"),
    OtherStyleBox.dogodek: HexColor.fromHex("#FFA500")
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
  
  return GestureDetector(child: Container(
    height: someValuesForSize.height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          colorsForStyles[styleOfBox],
          Colors.white,
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          blurRadius: 3,
          offset: Offset(4, 4), // Shadow position
        ),
    ],
    ),
    child: Stack(children: [Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.only(left:15),
        child:
        Row(
          children: [
            Text("${id<0?"":id.toString()+"."}", style: TextStyle(fontSize: someValuesForSize.primaryFontSize, color: textColorsForStyle[styleOfBox]),),
            Padding(padding: EdgeInsets.only(left: 20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${styleOfBox != OtherStyleBox.dogodek ? krajsava: dogodek}", style: TextStyle(fontSize: someValuesForSize.secundaryFontSize, color: textColorsForStyle[styleOfBox]),),
                Text("$trajanje", style: TextStyle(fontSize: someValuesForSize.secundaryFontSize, color: textColorsForStyle[styleOfBox]),)
            ],),
          ],),
        ),
        styleOfBox != OtherStyleBox.dogodek ?Padding(padding: EdgeInsets.only(right: 45), child: Text("$ucilnica", style: TextStyle(fontSize: someValuesForSize.primaryFontSize, color: textColorsForStyle[styleOfBox]), textAlign: TextAlign.center,),):SizedBox()
    ]),
    Positioned(child: Image.asset(imagesForStyle[styleOfBox], width: someValuesForSize.widthOfIcon, height: someValuesForSize.widthOfIcon,), right: 10, top: 10,),
  ])),
  );
}