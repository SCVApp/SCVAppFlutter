class EPASTimetable {
  int id;
  String name;
  DateTime start;
  DateTime end;
  int? selected_workshop_id = null;

  EPASTimetable({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
  });

  static fromJSON(json) {
    return EPASTimetable(
      id: json['id'],
      name: json['name'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  String getStartHour() {
    return start.hour.toString().padLeft(2, "0") +
        "." +
        start.minute.toString().padLeft(2, "0");
  }
}
