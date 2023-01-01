class Ura {
  String krajsava = "";
  String ucitelj = "";
  String ucilnica = "";
  String dogodek = "";
  bool nadomescanje = false;
  bool zaposlitev = false;
  bool odpadlo = false;

  void fromJSON(Map<String, dynamic> json) {
    this.krajsava = json["krajsava"];
    this.ucitelj = json["ucitelj"];
    this.ucilnica = json["ucilnica"];
    this.dogodek = json["dogodek"];
    this.nadomescanje = json["nadomescanje"];
    this.zaposlitev = json["zaposlitev"];
    this.odpadlo = json["odpadlo"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "krajsava": this.krajsava,
      "ucitelj": this.ucitelj,
      "ucilnica": this.ucilnica,
      "dogodek": this.dogodek,
      "nadomescanje": this.nadomescanje,
      "zaposlitev": this.zaposlitev,
      "odpadlo": this.odpadlo,
    };
  }
}
