enum UraType { nadomescanje, zaposlitev, odpadlo, normalno, dogodek }

class Ura {
  String krajsava = "";
  String ucitelj = "";
  String ucilnica = "";
  String dogodek = "";
  bool nadomescanje = false;
  bool zaposlitev = false;
  bool odpadlo = false;
  UraType type = UraType.normalno;

  void fromJSON(Map<String, dynamic> json) {
    this.krajsava = json["krajsava"];
    this.ucitelj = json["ucitelj"];
    this.ucilnica = json["ucilnica"];
    this.dogodek = json["dogodek"];
    this.nadomescanje = json["nadomescanje"];
    this.zaposlitev = json["zaposlitev"];
    this.odpadlo = json["odpadlo"];
    this.setType();
  }

  void setType() {
    if (this.dogodek != "") {
      this.type = UraType.dogodek;
    } else if (this.nadomescanje) {
      this.type = UraType.nadomescanje;
    } else if (this.zaposlitev) {
      this.type = UraType.zaposlitev;
    } else if (this.odpadlo) {
      this.type = UraType.odpadlo;
    } else {
      this.type = UraType.normalno;
    }
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
