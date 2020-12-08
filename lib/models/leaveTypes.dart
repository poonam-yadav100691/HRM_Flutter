import 'dart:convert';

List<LeaveTypes> todoFromJson(String str) => new List<LeaveTypes>.from(
    json.decode(str).map((x) => LeaveTypes.fromJson(x)));

String todoToJson(List<LeaveTypes> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveTypes {
  DateTime createdAt;
  DateTime updatedAt;
  int id;
  String user;
  String value;
  String status;

  LeaveTypes({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.user,
    this.value,
    this.status,
  });

  factory LeaveTypes.fromJson(Map<String, dynamic> json) => new LeaveTypes(
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        id: json["id"],
        user: json["user"],
        value: json["value"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "id": id,
        "user": user,
        "value": value,
        "status": status,
      };
}
