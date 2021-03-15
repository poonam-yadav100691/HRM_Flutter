class DelegateList {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  DelegateList(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  DelegateList.fromJson(Map<String, dynamic> json) {
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
  String delegatesId;
  String delegatesByName;
  String noted;
  String startDate;
  String endDate;
  String responseName;

  ResultObject(
      {this.delegatesId,
      this.delegatesByName,
      this.noted,
      this.startDate,
      this.endDate,
      this.responseName});

  ResultObject.fromJson(Map<String, dynamic> json) {
    delegatesId = json['delegatesId'];
    delegatesByName = json['delegatesByName'];
    noted = json['noted'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    responseName = json['responseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delegatesId'] = this.delegatesId;
    data['delegatesByName'] = this.delegatesByName;
    data['noted'] = this.noted;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['responseName'] = this.responseName;
    return data;
  }
}
