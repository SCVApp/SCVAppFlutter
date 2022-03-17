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

  @override
  Widget build(BuildContext context){
      return Scaffold(
        key:_scaffoldKey,
        body: Center(
          child: Column(
            children: <Widget>[
              ListTile(title:Text("Izbrana sola: " + widget.data.selectedId), onTap: (){
                showPicker(context);
              })
            ],
          ),
        ),
      );
  }

  List<PickerItem> items(){
    List<PickerItem> list = [];
    for (var i = 0; i < widget.data.sole.length; i++) {
      String id = widget.data.sole[i].id;
      if(id==widget.data.izbranaSola.id){
        selectedPickerItem = i;
      }
      PickerItem newPicker = new PickerItem(text:Text(id));
      list.add(newPicker);
    }
    return list;
  }

  showPicker(BuildContext context){
    Picker picker = new Picker(adapter: PickerDataAdapter(data: items()),selecteds: [selectedPickerItem],onConfirm: selectSchoolPicker);
    picker.show(_scaffoldKey.currentState);
  }

  selectSchoolPicker(Picker picker, List<int> list){
    if(list.length > 0){
      selectedPickerItem = list[0];
      String sId = widget.data.sole[list[0]].id;
      widget.data.shraniIzbranoSolo(sId);
    }
  }
}