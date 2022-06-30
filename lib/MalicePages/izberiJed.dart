import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scv_app/Components/backBtn.dart';
import 'package:scv_app/Components/komponeneteZaMalico.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';

class IzberiJedMalicePage extends StatefulWidget{
  IzberiJedMalicePage({Key key, this.title}) : super(key: key);

  final String title;

  _IzberiJedMalicePage createState() => _IzberiJedMalicePage();
}

class _IzberiJedMalicePage extends State<IzberiJedMalicePage>{

  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool prikazanKoledar = false;

  DateTime trenutnoIzbraniCas = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  
  
  List<malica_Jed_Izbira> maliceNaMenuju = [
    malica_Jed_Izbira(
      imeJedi: "Pac kar je danes za jest",
      slika: AssetImage("assets/slikeMalica/mesni_meni.png"),
      naslov: "Mesni meni",
    ),
    malica_Jed_Izbira(
      imeJedi: "Pac kar je danes za jest",
      slika: AssetImage("assets/slikeMalica/vegi_meni.png"),
      naslov: "Vegi meni",
      izbrana: true,
    ),
    malica_Jed_Izbira(
      imeJedi: "Klasična pizza",
      slika: AssetImage("assets/slikeMalica/pizza.png"),
      naslov: "Pizza",
    ),
    malica_Jed_Izbira(
      imeJedi: "Margarita pizza",
      slika: AssetImage("assets/slikeMalica/pizza_margerite.png"),
      naslov: "Pizza margerite",
    ),
    malica_Jed_Izbira(
      imeJedi: " Hamburger",
      slika: AssetImage("assets/slikeMalica/hamburger.png"),
      naslov: "Hamburger",
    ),
    malica_Jed_Izbira(
      imeJedi: "Solata",
      slika: AssetImage("assets/slikeMalica/solata.png"),
      naslov: "Solata",
    ),
    malica_Jed_Izbira(
      imeJedi: "Sendvič s tuno",
      slika: AssetImage("assets/slikeMalica/sendvic_s_tuno.png"),
      naslov: "Sendvič s tuno",
    ),
    malica_Jed_Izbira(
      imeJedi: "Kmečki sendvič",
      slika: AssetImage("assets/slikeMalica/kmecki_sendvic.png"),
      naslov: "Kmečki sendvič",
    ),
    malica_Jed_Izbira(
      imeJedi: "Sendvič s sirom",
      slika: AssetImage("assets/slikeMalica/sendvic_s_sirom.png"),
      naslov: "Sendvič s sirom",
    ),
    malica_Jed_Izbira(
      imeJedi: "Brez malice",
      slika: AssetImage("assets/slikeMalica/brez_malice.png"),
      naslov: "Brez malice",
    ),
  ];
  
  DateTime danasniDan = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  void izberaDatuma(DateRangePickerSelectionChangedArgs args){
      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(args.value.toString());
      if(tempDate.compareTo(danasniDan) >= 0){
        setState(() {
          this.prikazanKoledar = false;
          this.trenutnoIzbraniCas = tempDate;
        });
      }
  }

  void pojdiDanNazaj(){
    DateTime novo = this.trenutnoIzbraniCas.subtract(Duration(days: 1));
    if(novo.compareTo(danasniDan) >= 0){
      setState(() {
          this.trenutnoIzbraniCas = novo;
      });
    }
  }

  void pojdiDanNaprej(){
    setState(() {
    this.trenutnoIzbraniCas = this.trenutnoIzbraniCas.add(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
            GestureDetector(
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(left: 30)),
                          Icon(Icons.arrow_back_ios),
                          Text(
                            "Nazaj",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.of(context).pop(),
                      ),
                      Padding(padding: EdgeInsets.only(top:10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 35,
                              color: danasniDan.compareTo(trenutnoIzbraniCas) >= 0 ? Colors.grey:Theme.of(context).primaryColor,
                              ),
                            onTap: pojdiDanNazaj,
                          ),
                          GestureDetector(
                            child: Text(
                            "Izbrani datum: ${trenutnoIzbraniCas.day}.${trenutnoIzbraniCas.month}.${trenutnoIzbraniCas.year}",
                            style: TextStyle(
                              fontWeight: FontWeight.w900
                            ),
                            ),
                            onTap: (){
                              setState(() {
                                this.prikazanKoledar = !this.prikazanKoledar;
                              });
                            },
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 35,
                              ),
                            onTap: pojdiDanNaprej,
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                        Expanded(child: ListView.separated(
                          itemCount: maliceNaMenuju.length,
                          padding: EdgeInsets.only(left: 40,right: 40, bottom: 40),
                          separatorBuilder: (context,index){
                            return Padding(padding: EdgeInsets.only(top:15));
                          },
                          itemBuilder: (BuildContext contect, int index){
                            return maliceNaMenuju[index];
                          }
                        )),
                    ],
                ),
                onTap: (){
                  if(this.prikazanKoledar){
                    setState(() {
                      this.prikazanKoledar = false;
                    });
                  }
                },
            ),

              if(this.prikazanKoledar)
                Positioned(
                bottom:0,
                left:0,
                height: MediaQuery.of(context).size.height/2,
                child: SfDateRangePicker(
                  onSelectionChanged: izberaDatuma,
                  initialSelectedDate: trenutnoIzbraniCas,
                  view: DateRangePickerView.month,
                  backgroundColor: Theme.of(context).backgroundColor,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      weekendDays: [6,7],
                      numberOfWeeksInView: 6,
                      showTrailingAndLeadingDates: true
                  ),
                  allowViewNavigation: false,
                  showNavigationArrow: true,
                  initialDisplayDate: trenutnoIzbraniCas,
                  enablePastDates: false,
                  ),
                ),
            ],
          )
        ),
      );
  }
}

// WebView(initialUrl: "https://malice.scv.si/",javascriptMode: JavascriptMode.unrestricted,)