class MalicaMeni {
  int id;
  String opis;

  MalicaMeni.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    opis = json["menu"];
  }
}
