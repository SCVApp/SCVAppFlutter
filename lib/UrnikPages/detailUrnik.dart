
import 'package:flutter/material.dart';
import 'package:scv_app/UrnikPages/components/otherStyleBox.dart';
import 'package:scv_app/UrnikPages/urnikData.dart';
import 'package:scv_app/data.dart';

class DetailUrnik extends StatefulWidget{
  DetailUrnik(this.context,this.urnikData, {Key key, this.ucilnica = "", this.krajsava = "", this.id = 0, this.trajanje = "", this.dogodek = "", this.ucitelj = "", this.styleOfBox = OtherStyleBox.normalno}) : super(key: key);

  final BuildContext context;
  final UrnikData urnikData;
  final String ucilnica;
  final String krajsava;
  final int id;
  final String trajanje;
  final String dogodek;
  final String ucitelj;
  final OtherStyleBox styleOfBox;


  _DetailUrnikState createState() => _DetailUrnikState();
}
class _DetailUrnikState extends State<DetailUrnik>{
  @override
  Widget build(BuildContext context){

    final double mainFontSize = MediaQuery.of(context).size.width * 0.045;
    final double bigFontSize = MediaQuery.of(context).size.width * 0.069;
    final double spaceBetweenLines = 10;

    return Scaffold(
      body: SafeArea(child: Container(
        child:Column(
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
                          Text("${widget.id}. ura: ",style: TextStyle(fontSize: mainFontSize),),
                          Text("${widget.dogodek!=""?widget.dogodek:widget.krajsava}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainFontSize),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                      Text("Čas: ${widget.trajanje}", style: TextStyle(fontSize: mainFontSize),),
                      Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                      widget.styleOfBox != OtherStyleBox.dogodek ? Text("Profesor/ica: ${widget.ucitelj}", style: TextStyle(fontSize: mainFontSize)) : SizedBox(),
                    ],
                  ),
                  Positioned(child: Text("${widget.ucilnica}", style: TextStyle(fontSize: bigFontSize, fontWeight: FontWeight.w500),), right: 0, top: -5,),
                ],
                )
            ])
            ),
            padding: EdgeInsets.only(left: 37, right: 37),)
        ]))));
  }
}