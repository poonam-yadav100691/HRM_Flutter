class EmpRequestList {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  EmpRequestList(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  EmpRequestList.fromJson(Map<String, dynamic> json) {
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
  String empName;
  String empPosition;
  String dateRequest;
  String fileName;
  String attachedFile;
  String statusText;
  String empPhoto;

  ResultObject(
      {this.requestID,
      this.requestNo,
      this.requestType,
      this.empName,
      this.empPosition,
      this.dateRequest,
      this.fileName,
      this.attachedFile,
      this.empPhoto,
      this.statusText});

  ResultObject.fromJson(Map<String, dynamic> json) {
    requestID = json['requestID'];
    requestNo = json['requestNo'];
    requestType = json['requestType'];
    empName = json['empName'];
    empPosition = json['empPosition'];
    dateRequest = json['dateRequest'];
    fileName = json['fileName'];
    attachedFile = json['attachedFile'];
    statusText = json['statusText'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestID'] = this.requestID;
    data['requestNo'] = this.requestNo;
    data['requestType'] = this.requestType;
    data['empName'] = this.empName;
    data['empPosition'] = this.empPosition;
    data['dateRequest'] = this.dateRequest;
    data['fileName'] = this.fileName;
    data['attachedFile'] = this.attachedFile;
    data['statusText'] = this.statusText;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}
