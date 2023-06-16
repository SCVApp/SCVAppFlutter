class MalicaMeni {
  int id;
  String opis;
  int tip_id;

  MalicaMeni.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    opis = json["menu"];
    tip_id = json["menu_type_id"];
  }
}
