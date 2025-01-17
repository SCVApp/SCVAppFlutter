class ActiveUserType {
  String azureId = "";
  DateTime startTime = DateTime.now();
  DateTime? endTime;

  ActiveUserType(
      {required this.azureId, required this.startTime, required this.endTime});

  ActiveUserType.fromJson(Map<String, dynamic> json) {
    azureId = json['azure_id'] ?? "";
    startTime = DateTime.parse(json['start_time']);
    if (json['end_time'] != null) {
      endTime = DateTime.parse(json['end_time']);
    }
  }
}

class LockerWithActiveUserResult {
  int lockerId = 0;
  String lockerIdentifier = "";
  ActiveUserType? activeUser;

  LockerWithActiveUserResult(
      {required this.lockerId,
      required this.lockerIdentifier,
      this.activeUser});

  LockerWithActiveUserResult.fromJson(Map<String, dynamic> json) {
    lockerId = json['id'];
    lockerIdentifier = json['identifier'];
    if (json['current_user'] != null) {
      activeUser = ActiveUserType.fromJson(json['current_user']);
    }
  }
}
