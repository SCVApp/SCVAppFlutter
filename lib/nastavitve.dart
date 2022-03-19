import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String token = "";

  @override
  void initState() {
    super.initState();
    loadToken();
  }
  
  void loadToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      setState(() {
         token = prefs.getString(keyForAccessToken);
      });
    }catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){

      Future<void> odjava() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove(keyForAccessToken);
        prefs.remove(keyForRefreshToken);
        prefs.remove(keyForExpiresOn);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnBoardingPage()));
      }

      return Scaffold(
        key:_scaffoldKey,
        body: Center(
          child: Column(
            children: <Widget>[
              userInfo(odjava),
            ],
          ),
        ),
      );
  }

  Widget userInfo(odjava){

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        token == "" ? Image(image: AssetImage("assets/profilePicture.png")) :
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FadeInImage(
                  image: NetworkImage("$apiUrl/user/get/profilePicture",headers: {"Authorization":token})
                  ,placeholder: AssetImage("assets/profilePicture.png")
                  ,height: 100,),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.user.displayName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                  Text(widget.data.user.mail)
                ],
              ),
              TextButton(onPressed: odjava, child: Image(image: AssetImage("assets/odjava.png"),height: 32,)),
      ]
      );
  }
}