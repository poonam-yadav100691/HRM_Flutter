import 'dart:convert';

class PermissionResponse {
  final List<Permission> list;

  PermissionResponse({
    this.list,
  });

  factory PermissionResponse.fromJson(List<dynamic> parsedJson) {
    List<Permission> list = new List<Permission>();
    list = parsedJson.map((i) => Permission.fromJson(i)).toList();

    return new PermissionResponse(list: list);
  }
}

// List<Permission> todoFromJson(String str) => new List<Permission>.from(
//     json.decode(str).map((x) => Permission.fromJson(x)));

// String todoToJson(List<Permission> data) =>
//     json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

// factory PermissionResponse.fromJson(List<dynamic> parsedJson) {
//     List<Permission> list = new List<Permission>();
//     list = parsedJson.map((i) => Permission.fromJson(i)).toList();

//     return new PermissionResponse(list: list);
//   }

class Permission {
  String roleName;
  String app_permissionName;
  String app_view;
  String app_add;
  String app_edit;
  String app_action;
  String CountItem;

  Permission({
    this.roleName,
    this.app_permissionName,
    this.app_view,
    this.app_add,
    this.app_edit,
    this.app_action,
    this.CountItem,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => new Permission(
        roleName: json["roleName"],
        app_permissionName: json["app_permissionName"],
        app_view: json["app_view"],
        app_add: json["app_add"],
        app_edit: json["app_edit"],
        app_action: json["app_action"],
      CountItem:json["CountItem"],
      );

  Map<String, dynamic> toJson() => {
        "roleName": roleName,
        "app_permissionName": app_permissionName,
        "app_view": app_view,
        "app_add": app_add,
        "app_edit": app_edit,
        "app_action": app_action,
    "CountItem":CountItem,
      };
}
