import 'package:flutter/material.dart';

class OstaleInformacijeMalicePage extends StatefulWidget{
  OstaleInformacijeMalicePage({Key key, this.title}) : super(key: key);

  final String title;

  _OstaleInformacijeMalicePage createState() => _OstaleInformacijeMalicePage();
}

class _OstaleInformacijeMalicePage extends State<OstaleInformacijeMalicePage>{


  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: SafeArea(
          child: Column(
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    
                  ],
                ),
              )
            ],
          )
        ),
      );
  }
}