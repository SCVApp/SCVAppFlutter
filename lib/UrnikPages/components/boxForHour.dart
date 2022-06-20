import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/mainUrnik.dart';
import 'package:scv_app/UrnikPages/urnikData.dart';
import 'package:scv_app/data.dart';

class SomeValuseForSize{
  final double height;
  final double primaryFontSize;
  final double secundaryFontSize;
  SomeValuseForSize({this.height,this.primaryFontSize,this.secundaryFontSize});
}

final defualtStyleBox = new UrnikBoxStyle(bgColor: Colors.blue, primaryTextColor: Colors.white, secundaryTextColor: Colors.white);

Widget HourBoxUrnik({bool isSmall = false, UrnikBoxStyle urnikBoxStyle, UraTrajanje trajanjeUra}) {
  String krajsava = "";
  String ucilnica = "";
  int id = 0;
  String trajanje = "";
  int izbranaUra = 0;

  if(trajanjeUra != null && trajanjeUra.ura.length > 0){
    Ura ura = trajanjeUra.ura[izbranaUra];
    krajsava = ura.krajsava;
    ucilnica = ura.ucilnica;
    id = trajanjeUra.id;
    trajanje = trajanjeUra.trajanje;
  }else{
    krajsava = "/";
    ucilnica = "/";
    id = 0;
    trajanje = "/";
  }

  final SomeValuseForSize someValuesForSize = !isSmall ? 
  SomeValuseForSize(height: 90, primaryFontSize: 24, secundaryFontSize: 15) :
  SomeValuseForSize(height: 60, primaryFontSize: 20, secundaryFontSize: 13);
  return Container(
    height: someValuesForSize.height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: urnikBoxStyle != null ? urnikBoxStyle.bgColor : Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey[600].withOpacity(0.7),
          blurRadius: 3,
          offset: Offset(4, 4), // Shadow position
        ),
    ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.only(left:15),
        child:
        Row(
          children: [
            Text("$id.", style: TextStyle(fontSize: someValuesForSize.primaryFontSize, color: urnikBoxStyle != null ? urnikBoxStyle.primaryTextColor : Colors.white),),
            Padding(padding: EdgeInsets.only(left: 20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$krajsava", style: TextStyle(fontSize: someValuesForSize.secundaryFontSize, color: urnikBoxStyle != null ? urnikBoxStyle.primaryTextColor : Colors.white),),
                Text("$trajanje", style: TextStyle(fontSize: someValuesForSize.secundaryFontSize, color: urnikBoxStyle != null ? urnikBoxStyle.secundaryTextColor : Colors.white),)
            ],),
          ],),
        ),
        Padding(padding: EdgeInsets.only(right: 15), child: Text("$ucilnica", style: TextStyle(fontSize: someValuesForSize.primaryFontSize, color: urnikBoxStyle != null ? urnikBoxStyle.primaryTextColor : Colors.white),),)
    ]),
  );
}
