  class MyRequestsCalender {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  MyRequestsCalender(
      {this.modelErrors,
        this.resultObject,
        this.statusCode,
        this.isSuccess,
        this.commonErrors});

  MyRequestsCalender.fromJson(Map<String, dynamic> json) {
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
  String month;
  List<Event> Events;

  ResultObject(
      {this.month,
        this.Events
      });

  ResultObject.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    if (json['Events'] != null) {
      Events = new List<Event>();
      json['Events'].forEach((v) {
        Events.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RequestID'] = this.month;
    data['Events'] = this.Events;
    return data;
  }
}

class Event {
  String eventDate;
  String eventNoted;

  Event(
      {this.eventDate,
        this.eventNoted
      });

  Event.fromJson(Map<String, dynamic> json) {
    eventDate = json['eventDate'];
    eventNoted = json['eventNoted'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventDate'] = this.eventDate;
    data['eventNoted'] = this.eventNoted;
    return data;
  }
}
