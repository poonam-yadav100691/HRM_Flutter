class MyRequests {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  MyRequests(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  MyRequests.fromJson(Map<String, dynamic> json) {
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
  String requestID;
  String requestNo;
  String requestType;
  String managerName;
  String submitDate;
  String statusText;
  String fileName;
  String attachedFile;
  String otdate;

  ResultObject(
      {this.requestID,
      this.requestNo,
      this.requestType,
      this.submitDate,
      this.managerName,
      this.statusText,
      this.fileName,
      this.attachedFile,
      this.otdate});

  ResultObject.fromJson(Map<String, dynamic> json) {
    requestID = json['RequestID'];
    requestNo = json['RequestNo'];
    requestType = json['RequestType'];
    managerName = json['managerName'];
    submitDate = json['SubmitDate'];
    statusText = json["statusText"];
    fileName = json['fileName'];
    attachedFile = json['attachedFile'];
    otdate = json['otdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RequestID'] = this.requestID;
    data['RequestNo'] = this.requestNo;
    data['RequestType'] = this.requestType;
    data['managerName'] = this.managerName;
    data['SubmitDate'] = this.submitDate;
    data['RequestFor'] = this.fileName;
    data['statusText'] = this.statusText;
    data['attachedFile'] = this.attachedFile;
    data['otdate'] = this.otdate;

    return data;
  }
}
