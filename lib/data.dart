import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sola{
  String id;//ERS,SSG
  String homeUrl;
  String noviceUrl;
  String urnikUrl;
  Color color;

  Sola(String _id, String _homeUrl, String _noviceUrl, String _urnikUrl, Color _color){
    this.id = _id;
    this.homeUrl = _homeUrl;
    this.noviceUrl = _noviceUrl;
    this.urnikUrl = _urnikUrl;
    this.color = _color;
  }
}

class UserData {
  final String id;
  final String displayName;
  final String givenName;
  final String mail;
  final String mobilePhone;
  final String surname;
  final String userPrincipalName;

  const UserData(this.displayName, this.givenName,this.surname, this.mail, this.mobilePhone, this.id, this.userPrincipalName);
}

class Data{

  List<Sola> sole = [
    Sola("ERŠ", "https://ers.scv.si/sl/", "https://ers.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/24353264bf0bc2a4b9c7d30eb8093fc21bb6c766", Color.fromRGBO(0, 148, 217, 1)),
    Sola("ŠSD", "https://storitvena.scv.si/sl/", "https://storitvena.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/642f7c2194b696dce4345e4a06f14d3510784603", Color.fromRGBO(238, 91, 160, 1)),
    Sola("ŠSGO", "https://ssgo.scv.si/sl/", "https://ssgo.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/25447b9cd323fcb5b062a7a450fd3bff7da2b270", Color.fromRGBO(166, 206, 57, 1)),
    Sola("Gimnazija", "https://gimnazija.scv.si/", "https://gimnazija.scv.si/?cat=3", "https://www.easistent.com/urniki/b29317ef35a6e16dc2012e97a575322a8eae7f56", Color.fromRGBO(255, 202, 5, 1))
  ];

  Sola izbranaSola = Sola("ERŠ", "https://ers.scv.si/", "https://ers.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/24353264bf0bc2a4b9c7d30eb8093fc21bb6c766", Colors.blue);

  String selectedId = "ERŠ";

  Data(){
    loadData();
  }

  loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedId = prefs.getString('selectedId') ?? "ERŠ";
    izbranaSola = dobiSolo();
    var newUrl = prefs.getString('urnikUrl') ?? "";
    if(newUrl != ""){
      izbranaSola.urnikUrl = newUrl;
    }
  }

  Sola dobiSolo(){
      for (Sola sola in sole) {
        if(sola.id == selectedId){
          return sola;
        }
      }
      return Sola("ERŠ", "https://ers.scv.si/", "https://ers.scv.si/sl/kategorija/novice/", "https://www.easistent.com/urniki/24353264bf0bc2a4b9c7d30eb8093fc21bb6c766/", Colors.blue);
  }

  saveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedId', selectedId);
  }

  shraniIzbranoSolo(String id) async{
    if(id != selectedId){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('urnikUrl');
      selectedId = id;
      saveData();
      loadData();
    }
  }

  spremeniUrlUrnika(String newUrl) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('urnikUrl', newUrl);
    izbranaSola.urnikUrl = newUrl;
  }
  
}