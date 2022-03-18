import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'data.dart';

class NastavitvePage extends StatefulWidget{
  NastavitvePage({Key key, this.title,this.data}) : super(key: key);

  final String title;

  final Data data;

  _NastavitvePageState createState() => _NastavitvePageState();
}

class _NastavitvePageState extends State<NastavitvePage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  void odjava(){

  }

  @override
  Widget build(BuildContext context){
      return Scaffold(
        key:_scaffoldKey,
        body: Center(
          child: Column(
            children: <Widget>[
              TextButton(onPressed: odjava, child: Text("Odjavi se!"))
            ],
          ),
        ),
      );
  }



  selectSchoolPicker(Picker picker, List<int> list){
    if(list.length > 0){
      selectedPickerItem = list[0];
      String sId = widget.data.sole[list[0]].id;
      widget.data.shraniIzbranoSolo(sId);
    }
  }
}