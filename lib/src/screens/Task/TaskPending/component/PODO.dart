class TaskList {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  TaskList(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  TaskList.fromJson(Map<String, dynamic> json) {
    modelErrors = json['ModelErrors'];
    if (json['ResultObject'] != null) {
      resultObject = new List<ResultObject>();
      json['ResultObject'].forEach((v) {
        resultObject.add(new ResultObject.fromJson(v));
      });
    }
    statusCode = json['StatusCode'];
    isSuccess = json['IsSuccess'];
    commonErrors = json['CommonErrors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ModelErrors'] = this.modelErrors;
    if (this.resultObject != null) {
      data['ResultObject'] = this.resultObject.map((v) => v.toJson()).toList();
    }
    data['StatusCode'] = this.statusCode;
    data['IsSuccess'] = this.isSuccess;
    data['CommonErrors'] = this.commonErrors;
    return data;
  }
}

class ResultObject {
  String taskID;
    String taskName;
  String taskDetail;
  String createTask;
  String asignTo;
  String filePath;
  String taskAttachedfile;
  bool taskStatus;

  ResultObject(
      {this.taskID,
      this.taskName,
      this.taskDetail,
      this.createTask,
      this.asignTo,
      this.filePath,
      this.taskAttachedfile,
      this.taskStatus});

  ResultObject.fromJson(Map<String, dynamic> json) {
    taskID = json['taskID'];
    taskName = json['taskName'];
    taskDetail = json['taskDetail'];
    createTask = json['createTask'];
    asignTo = json['asignTo'];
    filePath = json['file_path'];
    taskAttachedfile = json['taskAttachedfile'];
    taskStatus = json['taskStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskID'] = this.taskID;
    data['taskName'] = this.taskName;
    data['taskDetail'] = this.taskDetail;
    data['createTask'] = this.createTask;
    data['asignTo'] = this.asignTo;
    data['file_path'] = this.filePath;
    data['taskAttachedfile'] = this.taskAttachedfile;
    data['taskStatus'] = this.taskStatus;
    return data;
  }
}
