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
  String requestTitle;
  String strDate;
  String endDate;
  String returnDate;
  String managerName;
  String date_request;
  String requestFor;
  String statusText;
  String lang;

  ResultObject(
      {this.requestID,
      this.requestNo,
      this.requestType,
      this.requestTitle,
      this.strDate,
      this.endDate,
      this.date_request,
      this.managerName,
      this.requestFor,
      this.returnDate,
        this.statusText,
      this.lang});

  ResultObject.fromJson(Map<String, dynamic> json) {
    requestID = json['RequestID'];
    requestNo = json['RequestNo'];
    requestType = json['RequestType'];
    requestTitle = json['RequestTitle'];
    strDate = json['strDate'];
    endDate = json['endDate'];
    returnDate = json['returnDate'];
    managerName = json['managerName'];
    date_request = json['date_request'];
    requestFor = json['RequestFor'];
    statusText=json["statusText"];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RequestID'] = this.requestID;
    data['RequestNo'] = this.requestNo;
    data['RequestType'] = this.requestType;
    data['RequestTitle'] = this.requestTitle;
    data['strDate'] = this.strDate;
    data['endDate'] = this.endDate;
    data['returnDate'] = this.returnDate;
    data['managerName'] = this.managerName;
    data['date_request'] = this.date_request;
    data['RequestFor'] = this.requestFor;
    data['statusText']=this.statusText;
    data['lang'] = this.lang;
    return data;
  }
}
