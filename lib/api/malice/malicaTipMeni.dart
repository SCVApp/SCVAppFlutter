class MalicaTipMeni {
  int id;
  String naziv;
  String picture_url;

  MalicaTipMeni.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    naziv = json["title"];
    picture_url =
        naziv.replaceAll(" ", "_").replaceAll("č", "c").toLowerCase() + ".png";
  }
}
