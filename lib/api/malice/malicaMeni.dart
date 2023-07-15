class MalicaMeni {
  int id = 0;
  String opis = "";
  int tip_id = 0;

  MalicaMeni.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    opis = json["menu"];
    tip_id = json["menu_type_id"];
  }
}
