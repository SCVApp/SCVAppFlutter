import 'dart:convert';

import 'package:scv_app/api/urnik/obdobjaUr.dart';
import 'package:scv_app/global/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'passDoor.dart';
import 'ura.dart';

enum PoukType { zacetekPouka, konecPouka, odmor, pouk, niPouka }

class Urnik {
  List<ObdobjaUr> obdobjaUr = [];
  PoukType poukType = PoukType.niPouka;
  bool loadingFromWeb = false;
  List<PassDoor> passDoors = [];
  DateTime nazadnjePosodobljeno = DateTime.fromMillisecondsSinceEpoch(0);

  static final String urnikKey = "SCV-App-Urnik";

  String doNaslednjeUre = "";

  Future<void> fetchFromWeb({bool force = false}) async {
    await global.token.refresh();
    try {
      final response = await http.get(
          Uri.parse('${global.apiUrl}/user/schedule'),
          headers: {"Authorization": global.token.getAccessToken()});
      if (response.statusCode == 200) {
        this.fromJSON(jsonDecode(response.body));
        this.nazadnjePosodobljeno = DateTime.now();
        await this.save();
        if (force) {
          global.showGlobalAlert(text: "Urnik uspešno posodobljen");
        }
      }
    } catch (e) {
      global.showGlobalAlert(text: "Napaka pri nalaganju urnika");
    }
    this.loadingFromWeb = false;
  }

  Future<void> fetchPassDoor() async {
    try {
      final response = await http.get(
          Uri.parse('${global.apiUrl}/pass/all_doors_user'),
          headers: {"Authorization": global.token.getAccessToken()});
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        this.passDoors = json.map((e) => PassDoor.fromJSON(e)).toList();
      }
    } catch (_) {}
    for (ObdobjaUr obdobjeUr in this.obdobjaUr) {
      for (Ura ura in obdobjeUr.ure) {
        for (PassDoor passDoor in this.passDoors) {
          if (ura.ucilnica == passDoor.name_id) {
            ura.smartDoorCode = passDoor.code;
          }
        }
      }
    }
  }

  Future<void> refresh({bool forceFetch = false}) async {
    final Duration differenceFromLoadedAndNow =
        this.nazadnjePosodobljeno.difference(DateTime.now()).abs();
    if (differenceFromLoadedAndNow.inHours >= 1 || forceFetch) {
      await this.fetchFromWeb(force: forceFetch);
    }
    await this.fetchPassDoor();
    this.loadingFromWeb = false;
  }

  void fromJSON(Map<String, dynamic> json) {
    if (json["nazadnjePosodobljeno"] != null) {
      this.nazadnjePosodobljeno = DateTime.parse(json["nazadnjePosodobljeno"]);
    }
    this.obdobjaUr.clear();
    int firstEmptyElementInTheEnd = -1;
    int index = 0;
    for (var obdobje in json["urnik"]) {
      ObdobjaUr obdobjaUr = new ObdobjaUr();
      obdobjaUr.fromJSON(obdobje);
      this.obdobjaUr.add(obdobjaUr);
      if (obdobjaUr.obdobjeJePrazno()) {
        if (firstEmptyElementInTheEnd == -1) {
          firstEmptyElementInTheEnd = index;
        }
      } else {
        firstEmptyElementInTheEnd = -1;
      }
      index++;
    }
    if (firstEmptyElementInTheEnd != -1) {
      this
          .obdobjaUr
          .removeRange(firstEmptyElementInTheEnd, this.obdobjaUr.length);
    }
    this.setTypeForObdobjaUr();
  }

  Map<String, dynamic> toJson() => {
        "urnik": this.obdobjaUr,
        "nazadnjePosodobljeno": this.nazadnjePosodobljeno.toString(),
      };

  Future<void> save() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String json = jsonEncode(this);
      await prefs.setString(urnikKey, json);
    } catch (e) {
      global.showGlobalAlert(text: "Napaka pri shranjevanju urnika");
    }
  }

  Future<void> load() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? urnik = prefs.getString(urnikKey);
      if (urnik != null) {
        this.fromJSON(jsonDecode(urnik));
      }
    } catch (e) {
      global.showGlobalAlert(text: "Napaka pri nalaganju urnika");
    }
  }

  Future<void> delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(urnikKey);
  }

  void setTypeForObdobjaUr() {
    final DateTime now = DateTime.now();
    int indexZaTreutno = -1;
    int indexZaNaslednje = -1;
    this.poukType = PoukType.niPouka;
    for (int i = 0; i < this.obdobjaUr.length; i++) {
      ObdobjaUr obdobje = this.obdobjaUr[i];
      if (obdobje.zacetek.isBefore(now) && obdobje.konec.isAfter(now)) {
        obdobje.type = ObdobjaUrType.trenutno;
        indexZaTreutno = i;
        if (obdobje.obdobjeJePrazno()) {
          this.poukType = PoukType.odmor;
        } else {
          this.poukType = PoukType.pouk;
        }
      } else {
        obdobje.type = ObdobjaUrType.normalno;
      }

      if (indexZaTreutno != -1) {
        if (i == indexZaTreutno + 1) {
          obdobje.type = ObdobjaUrType.naslednje;
        }
      } else {
        if (i == 0) {
          if (obdobje.zacetek.isAfter(now)) {
            obdobje.type = ObdobjaUrType.naslednje;
            this.poukType = PoukType.zacetekPouka;
          }
        } else {
          if (obdobje.zacetek.isAfter(now) &&
              this.obdobjaUr[i - 1].konec.isBefore(now)) {
            obdobje.type = ObdobjaUrType.naslednje;
            this.poukType = PoukType.odmor;
          }
        }
      }
      if (obdobje.type == ObdobjaUrType.naslednje) {
        indexZaNaslednje = i;
      }
    }

    if (this.obdobjaUr.length == 0) {
      this.poukType = PoukType.niPouka;
    } else if (indexZaTreutno == -1 && indexZaNaslednje == -1) {
      this.poukType = PoukType.konecPouka;
    }

    minutesAndSecundsToNextObdobjeUr();
  }

  void minutesAndSecundsToNextObdobjeUr() {
    DateTime now = DateTime.now();
    ObdobjaUr? naslednjeObdobje = this
        .obdobjaUr
        .firstWhere((element) => element.type == ObdobjaUrType.naslednje);
    if (naslednjeObdobje != null) {
      Duration duration = naslednjeObdobje.zacetek.difference(now);
      if (duration.inSeconds < 0) {
        this.doNaslednjeUre = "";
        return;
      }
      this.doNaslednjeUre =
          "${duration.inMinutes}min in ${duration.inSeconds % 60}s";
    } else {
      ObdobjaUr? trenutnoObdobje = this
          .obdobjaUr
          .firstWhere((element) => element.type == ObdobjaUrType.trenutno);
      if (trenutnoObdobje != null) {
        Duration duration = trenutnoObdobje.konec.difference(now);
        if (duration.inSeconds < 0) {
          this.doNaslednjeUre = "";
          return;
        }
        this.doNaslednjeUre =
            "${duration.inMinutes}min in ${duration.inSeconds % 60}s";
      } else {
        this.doNaslednjeUre = "";
      }
    }
  }

  String zacetekNaslednjegaObdobja() {
    ObdobjaUr? naslednjeObdobje = this.obdobjaUr.firstWhere(
          (element) => element.type == ObdobjaUrType.naslednje);
    if (naslednjeObdobje == null) return "";
    if (naslednjeObdobje.obdobjeJePrazno()) {
      for (int i = this.obdobjaUr.indexOf(naslednjeObdobje);
          i < this.obdobjaUr.length;
          i++) {
        if (!this.obdobjaUr[i].obdobjeJePrazno()) {
          naslednjeObdobje = this.obdobjaUr[i];
          break;
        }
      }
    }
    String hours = naslednjeObdobje!.zacetek.hour.toString();
    if (hours.length == 1) hours = "0$hours";
    String minutes = naslednjeObdobje.zacetek.minute.toString();
    if (minutes.length == 1) minutes = "0$minutes";
    return "$hours.$minutes";
  }

  void preveriCeJeUrnikOsvezenDanes() {
    DateTime now = DateTime.now();
    if (this.nazadnjePosodobljeno.day != now.day ||
        this.nazadnjePosodobljeno.month != now.month ||
        this.nazadnjePosodobljeno.year != now.year) {
      this.delete();
      this.loadingFromWeb = true;
    }
  }
}
