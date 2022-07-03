
import 'package:flutter/material.dart';
import 'package:scv_app/data.dart';

Widget DetailUrnik(BuildContext context, UrnikData urnikData) {
  final double mainFontSize = 17;
  final double spaceBetweenLines = 10;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
      TextButton(onPressed: (){}, child: Icon(Icons.arrow_back_ios_new, size: 25, color: Theme.of(context).primaryColor,),),
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
                      Text("1. ura: ",style: TextStyle(fontSize: mainFontSize),),
                      Text("FIZ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainFontSize),),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                  Text("Čas: 8.50 - 9.35", style: TextStyle(fontSize: mainFontSize),),
                  Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                  Text("Profesor/ica: Samo Gnilšek", style: TextStyle(fontSize: mainFontSize)),
                ],
              ),
              Positioned(child: Text("C305", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),), right: 0, top: -5,),
            ],
            )
        ])
        ),
        padding: EdgeInsets.only(left: 37, right: 37),)
    ]);
}