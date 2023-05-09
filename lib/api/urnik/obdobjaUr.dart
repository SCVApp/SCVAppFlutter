import 'package:scv_app/api/urnik/ura.dart';
import 'package:intl/intl.dart';

enum ObdobjaUrType { trenutno, naslednje, normalno }

class ObdobjaUr {
  int id = 0;
  String ime = "";
  String trajanje = "";
  DateTime zacetek = DateTime.now();
  DateTime konec = DateTime.now();
  List<Ura> ure = [];
  String datum = "";
  ObdobjaUrType type = ObdobjaUrType.normalno;

  void fromJSON(Map<String, dynamic> json) {
    this.id = json["id"];
    this.ime = json["ime"];
    this.trajanje = json["trajanje"];
    this.trajanje = this.trajanje.replaceAll(":", ".");
    this.parseDateTimeFromTrajanje();
    for (var ura in json["ura"]) {
      Ura ura_ = new Ura();
      ura_.fromJSON(ura);
      this.ure.add(ura_);
    }
    this.datum = DateFormat("EEE, d.M.yyyy", "sl_SI").format(DateTime.now());
  }

  void parseDateTimeFromTrajanje() {
    try {
      List<String> trajanje = this.trajanje.split(" - ");
      this.zacetek = parseDateTimeFromString(trajanje[0]);
      this.konec = parseDateTimeFromString(trajanje[1]);
    } catch (e) {
      print(e);
    }
  }

  DateTime parseDateTimeFromString(String hourAndMinute) {
    List<String> hourAndMinuteList = hourAndMinute.split(".");
    DateTime dateTime = DateTime.now();
    int hour = int.parse(hourAndMinuteList[0]);
    int minute = int.parse(hourAndMinuteList[1]);
    return DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "ime": this.ime,
        "trajanje": this.trajanje,
        "ura": this.ure,
      };

  bool obdobjeJePrazno() {
    for (Ura ura in this.ure) {
      if (ura.uraJePrazna() == false) {
        return false;
      }
    }
    return true;
  }
}
