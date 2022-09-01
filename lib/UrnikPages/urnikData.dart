import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scv_app/UrnikPages/mainUrnik.dart';
import 'package:scv_app/data.dart';
import 'package:scv_app/prijava.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UreUrnikData {
  List<UraTrajanje> urnikUre = [];
  int zacetekNaslednjeUre = -1;

  ///Ključ za shranjevanje urnika v spomin telefona
  final String urnikDataKey = "urnikDataKey";
  DateTime lastUpdate = DateTime.now();

  Future<void> getFromWeb(String token, {bool force = false}) async {
    DateTime casZdaj = DateTime.now();
    if (casZdaj.day != lastUpdate.day ||
        casZdaj.month != lastUpdate.month ||
        casZdaj.year != lastUpdate.year ||
        force) {
      final response = await http.get(Uri.parse('$apiUrl/user/schedule'),
          headers: {"Authorization": token});
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        this.fromJson(json, true);
      }
      print("Update urnik from web");
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("Update urnik same day");
      this.getFromPrefs(prefs);
    }
  }

  void getFromPrefs(SharedPreferences prefs) async {
    try {
      var json = prefs.getString(urnikDataKey);
      if (json != null) {
        this.fromJson(jsonDecode(json), false);
      } else {
        this.lastUpdate = this.lastUpdate.subtract(Duration(days: 2));
      }
    } catch (e) {
      this.lastUpdate = this.lastUpdate.subtract(Duration(days: 2));
      print("Error getting from prefs");
    }
  }

  void fromJson(var json, bool fromWeb) {
    var urnik = json["urnik"];
    var datum = json["datum"];
    this.urnikUre.clear();
    for (int i = 0; i < urnik.length; i++) {
      this.urnikUre.add(UraTrajanje.fromJson(urnik[i]));
    }
    if (datum != null) {
      this.lastUpdate = DateTime.parse(datum);
    }
    this.pocistiUreObKoncuPouka();
    if (fromWeb) {
      this.saveData();
    }
  }

  void prikaziTrenutnoUro(UrnikData urnikData) {
    int casZdaj = DateTime.now().millisecondsSinceEpoch;
    int idTrenutneUre = -1;
    for (UraTrajanje uraTrajanje in this.urnikUre) {
      if (uraTrajanje.zacetek.millisecondsSinceEpoch <= casZdaj &&
          casZdaj <= uraTrajanje.konec.millisecondsSinceEpoch) {
        uraTrajanje.style = urnikData.nowStyle;
        idTrenutneUre = uraTrajanje.id;
      } else {
        uraTrajanje.style = urnikData.otherStyle;
      }
    }

    for (int i = 0; i < this.urnikUre.length; i++) {
      UraTrajanje uraTrajanje = this.urnikUre[i];
      if (idTrenutneUre == -1) {
        if (i == 0) {
          if (uraTrajanje.zacetek.millisecondsSinceEpoch > casZdaj) {
            uraTrajanje.style = urnikData.nextStyle;
            this.zacetekNaslednjeUre =
                uraTrajanje.zacetek.millisecondsSinceEpoch;
          }
        } else {
          if (this.urnikUre[i - 1].konec.millisecondsSinceEpoch < casZdaj &&
              uraTrajanje.zacetek.millisecondsSinceEpoch > casZdaj) {
            uraTrajanje.style = urnikData.nextStyle;
            this.zacetekNaslednjeUre =
                uraTrajanje.zacetek.millisecondsSinceEpoch;
          }
        }
      } else {
        if (uraTrajanje.id == idTrenutneUre + 1) {
          uraTrajanje.style = urnikData.nextStyle;
          this.zacetekNaslednjeUre = uraTrajanje.zacetek.millisecondsSinceEpoch;
        }
      }
    }
  }

  String doNaslednjeUre() {
    if (this.zacetekNaslednjeUre == -1) return "";
    int casZdaj = DateTime.now().millisecondsSinceEpoch;
    Duration duration =
        new Duration(milliseconds: this.zacetekNaslednjeUre - casZdaj);
    if (duration.inSeconds < 0) {
      return "";
    }
    return duration.inMinutes.toString() +
        "min in " +
        (duration.inSeconds - (duration.inMinutes * 60)).toString() +
        "s";
  }

  void pocistiUreObKoncuPouka() {
    int prvaPraznaUra = -1;
    for (int i = 0; i < this.urnikUre.length; i++) {
      UraTrajanje uraTrajanje = this.urnikUre[i];
      if (uraTrajanje.aliSoUrePrazne() == true) {
        if (prvaPraznaUra == -1) {
          prvaPraznaUra = i;
        }
      } else {
        prvaPraznaUra = -1;
      }
    }
    if (prvaPraznaUra > -1) {
      this.urnikUre.removeRange(prvaPraznaUra, this.urnikUre.length);
    }
  }

  Map<String, dynamic> toJson() => {
        "datum": DateTime.now().toString(),
        "urnik": this.urnikUre,
      };

  void saveData() async {
    String jsonString = jsonEncode(this);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.urnikDataKey, jsonString);
  }
}

class UraTrajanje {
  int id = 0;
  String ime = "";
  String trajanje = "";
  DateTime zacetek = DateTime.now();
  DateTime konec = DateTime.now();
  List<Ura> ura = [];
  UrnikBoxStyle style = null;

  static UraTrajanje fromJson(var uraTrajanje) {
    UraTrajanje result = new UraTrajanje();
    result.id = uraTrajanje["id"];
    result.ime = uraTrajanje["ime"];
    result.trajanje = uraTrajanje["trajanje"];
    var ure = uraTrajanje["ura"];
    for (int i = 0; i < ure.length; i++) {
      result.ura.add(Ura.fromJson(ure[i]));
    }
    result.trajanje = result.trajanje.replaceAll(":", ".");
    try {
      DateTime casZdaj = DateTime.now(); //Trenutni cas

      //Pretvorimo v datetime za zacetek ure
      String zacetekS = result.trajanje.split("-")[0].trim();

      String zacetekH = zacetekS.split(".")[0];
      String zacetekM = zacetekS.split(".")[1];
      result.zacetek = DateTime(casZdaj.year, casZdaj.month, casZdaj.day,
          int.parse(zacetekH), int.parse(zacetekM));

      //Pretvorimo v datetime za konec ure
      String konecS = result.trajanje.split("-")[1].trim();

      String konecH = konecS.split(".")[0];
      String konecM = konecS.split(".")[1];
      result.konec = DateTime(casZdaj.year, casZdaj.month, casZdaj.day,
          int.parse(konecH), int.parse(konecM));
    } catch (e) {
      print("Error: $e");
    }

    return result;
  }

  bool aliSoUrePrazne() {
    for (Ura ura in this.ura) {
      if (ura.ucitelj != "" ||
          ura.ucilnica != "" ||
          ura.krajsava != "" ||
          ura.dogodek != "") {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "ime": this.ime,
        "trajanje": this.trajanje,
        "ura": this.ura,
      };
}

class Ura {
  String krajsava = "";
  String ucitelj = "";
  String ucilnica = "";
  String dogodek = "";
  bool nadomescanje = false;
  bool zaposlitev = false;
  bool odpadlo = false;

  static Ura fromJson(var ura) {
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

  Map<String, dynamic> toJson() => {
        "krajsava": this.krajsava,
        "ucitelj": this.ucitelj,
        "ucilnica": this.ucilnica,
        "dogodek": this.dogodek,
        "nadomescanje": this.nadomescanje,
        "zaposlitev": this.zaposlitev,
        "odpadlo": this.odpadlo,
      };
}
