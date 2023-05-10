class PassDoor {
  String name_id;
  String code;

  PassDoor({this.name_id, this.code});

  static PassDoor fromJSON(Map<String, dynamic> json) {
    return PassDoor(
      name_id: json["name_id"],
      code: json["code"],
    );
  }
}
