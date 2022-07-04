
import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/components/otherStyleBox.dart';
import 'package:scv_app/UrnikPages/urnikData.dart';
import 'package:scv_app/data.dart';

Widget DetailUrnik(BuildContext context, UrnikData urnikData, {String ucilnica = "", String krajsava = "", int id = 0, String trajanje = "", String ucitelj = "", String dogodek = "", OtherStyleBox styleOfBox = OtherStyleBox.normalno}) {
  final double mainFontSize = MediaQuery.of(context).size.width * 0.045;
  final double bigFontSize = MediaQuery.of(context).size.width * 0.069;
  final double spaceBetweenLines = 10;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: Icon(Icons.arrow_back_ios_new, size: 25, color: Theme.of(context).primaryColor,),),
      Padding(child: Container(
        // height: 150,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 3,
              offset: Offset(4, 4), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Stack(
            children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("$id. ura: ",style: TextStyle(fontSize: mainFontSize),),
                      Text("${dogodek!=""?dogodek:krajsava}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainFontSize),),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                  Text("Čas: $trajanje", style: TextStyle(fontSize: mainFontSize),),
                  Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                  styleOfBox != OtherStyleBox.dogodek ? Text("Profesor/ica: $ucitelj", style: TextStyle(fontSize: mainFontSize)) : SizedBox(),
                ],
              ),
              Positioned(child: Text("$ucilnica", style: TextStyle(fontSize: bigFontSize, fontWeight: FontWeight.w500),), right: 0, top: -5,),
            ],
            )
        ])
        ),
        padding: EdgeInsets.only(left: 37, right: 37),)
    ]);
}