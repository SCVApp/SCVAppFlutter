import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scv_app/UrnikPages/mainUrnik.dart';
import 'package:scv_app/data.dart';
import 'package:scv_app/prijava.dart';

class UreUrnikData{
  List<UraTrajanje> urnikUre = [];

  Future<void> getFromWeb(String token) async{
    final response = await http
      .get(Uri.parse('$apiUrl/user/schedule'),headers: {"Authorization":token});
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      this.fromJson(json);
    }
  }

  void fromJson(var json){
    var urnik = json["urnik"];
      for(int i = 0;i<urnik.length;i++){
        this.urnikUre.add(UraTrajanje.fromJson(urnik[i]));
      }
  }

  void prikaziTrenutnoUro(UrnikData urnikData){
    int casZdaj = DateTime.now().subtract(const Duration(hours: 10)).millisecondsSinceEpoch;
    int idTrenutneUre = -1;
    for(UraTrajanje uraTrajanje in this.urnikUre){
      if(uraTrajanje.zacetek.millisecondsSinceEpoch <= casZdaj && casZdaj <= uraTrajanje.konec.millisecondsSinceEpoch){
        uraTrajanje.style = urnikData.nowStyle;
        idTrenutneUre = uraTrajanje.id;
      }else if(uraTrajanje.id - 1 == idTrenutneUre){
        uraTrajanje.style = urnikData.nextStyle;
      }
      else{
        uraTrajanje.style = urnikData.otherStyle;
      }
    }
  }
}

class UraTrajanje{
  int id = 0;
  String ime = "";
  String trajanje = "";
  DateTime zacetek = DateTime.now();
  DateTime konec = DateTime.now();
  List<Ura> ura = [];
  UrnikBoxStyle style = null;

  static UraTrajanje fromJson (var uraTrajanje){
    UraTrajanje result = new UraTrajanje();
    result.id = uraTrajanje["id"];
    result.ime = uraTrajanje["ime"];
    result.trajanje = uraTrajanje["trajanje"];
    var ure = uraTrajanje["ura"];
    for(int i = 0;i<ure.length;i++){
      result.ura.add(Ura.fromJson(ure[i]));
    }

    try{
      DateTime casZdaj = DateTime.now();//Trenutni cas

      //Pretvorimo v datetime za zacetek ure
      String zacetekS = result.trajanje.split("-")[0].trim();

      String zacetekH = zacetekS.split(":")[0];
      String zacetekM = zacetekS.split(":")[1];
      result.zacetek = DateTime(casZdaj.year,casZdaj.month,casZdaj.day,int.parse(zacetekH),int.parse(zacetekM));


      //Pretvorimo v datetime za konec ure
      String konecS = result.trajanje.split("-")[1].trim();

      String konecH = konecS.split(":")[0];
      String konecM = konecS.split(":")[1];
      result.konec = DateTime(casZdaj.year,casZdaj.month,casZdaj.day,int.parse(konecH),int.parse(konecM));
    }catch(e){
      print("Error: $e");
    }

    result.trajanje = result.trajanje.replaceAll(":", ".");

    return result;
  }
}

class Ura{
  String krajsava = "";
  String ucitelj = "";
  String ucilnica = "";
  String dogodek = "";
  bool nadomescanje = false;
  bool zaposlitev = false;
  bool odpadlo = false;

  static Ura fromJson(var ura){
    Ura result = new Ura();
    result.krajsava = ura["krajsava"];
    result.ucitelj = ura["ucitelj"];
    result.ucilnica = ura["ucilnica"];
    result.dogodek = ura["dogodek"];
    result.nadomescanje = ura["nadomescanje"];
    result.zaposlitev = ura["zaposlitev"];
    result.odpadlo = ura["odpadlo"];

    return result;
  }
}