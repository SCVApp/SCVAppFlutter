
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

  final double paddingInSizeBox = 15;
  final double paddingFromScreenStartEnd = 37;

  Widget content(){
    return LayoutBuilder(builder: ((context, constraints) {
      final double mainFontSize = MediaQuery.of(context).size.width * 0.045;
      final double bigFontSize = MediaQuery.of(context).size.width * 0.069;
      final double spaceBetweenLines = 10;

      var textForClass = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: '${widget.ucilnica}',
            style: TextStyle(fontSize: bigFontSize, fontWeight: FontWeight.w500)
          ),
      );
      textForClass.layout();
      double sizeForRichText = MediaQuery.of(context).size.width - (2*paddingFromScreenStartEnd) - (2*paddingInSizeBox) - textForClass.size.width - 10;
      return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: sizeForRichText,
                          child:RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(text:"${widget.id}. ura: ",style: TextStyle(fontSize: mainFontSize),),
                              TextSpan(text:"${widget.dogodek!=""?widget.dogodek:widget.krajsava}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainFontSize),),
                            ],
                          ),
                        )),
                        Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                        Text("Čas: ${widget.trajanje}", style: TextStyle(fontSize: mainFontSize),),
                        Padding(padding: EdgeInsets.only(top: spaceBetweenLines)),
                        widget.styleOfBox != OtherStyleBox.dogodek ? Text("Profesor/ica: ${widget.ucitelj}", style: TextStyle(fontSize: mainFontSize)) : SizedBox(),
                      ],
                  ),
                  Positioned(child: Text(textForClass.text.toPlainText(), style: textForClass.text.style,), right: 0, top: -5,),
                ],
                ));
    }));
  }

  @override
  Widget build(BuildContext context){

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
            padding: EdgeInsets.all(paddingInSizeBox),
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
                this.content()
            ])
            ),
            padding: EdgeInsets.only(left: paddingFromScreenStartEnd, right: paddingFromScreenStartEnd),)
        ]))));
  }
}