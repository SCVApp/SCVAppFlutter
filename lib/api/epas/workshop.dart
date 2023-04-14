class EPASWorkshop {
  int id;
  String name;
  String description;
  int timetable_id;

  EPASWorkshop({
    this.id,
    this.name,
    this.description,
    this.timetable_id,
  });

  static fromJSON(json, int timetable_id) {
    return EPASWorkshop(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      timetable_id: timetable_id,
    );
  }
}
