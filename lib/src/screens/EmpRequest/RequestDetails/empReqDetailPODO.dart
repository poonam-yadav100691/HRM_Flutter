class EmpReqDetails {
  String modelErrors;
  List<RequestTitleObject> requestTitleObject;
  List<ApprovedObject> approvedObject;
  List<RequestItemObject> requestItemObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  EmpReqDetails(
      {this.modelErrors,
      this.requestTitleObject,
      this.approvedObject,
      this.requestItemObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  EmpReqDetails.fromJson(Map<String, dynamic> json) {
    modelErrors = json['ModelErrors'];
    if (json['RequestTitleObject'] != null) {
      requestTitleObject = new List<RequestTitleObject>();
      json['RequestTitleObject'].forEach((v) {
        requestTitleObject.add(new RequestTitleObject.fromJson(v));
      });
    }
    if (json['ApprovedObject'] != null) {
      approvedObject = new List<ApprovedObject>();
      json['ApprovedObject'].forEach((v) {
        approvedObject.add(new ApprovedObject.fromJson(v));
      });
    }
    if (json['RequestItemObject'] != null) {
      requestItemObject = new List<RequestItemObject>();
      json['RequestItemObject'].forEach((v) {
        requestItemObject.add(new RequestItemObject.fromJson(v));
      });
    }
    statusCode = json['StatusCode'];
    isSuccess = json['IsSuccess'];
    commonErrors = json['CommonErrors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ModelErrors'] = this.modelErrors;
    if (this.requestTitleObject != null) {
      data['RequestTitleObject'] =
          this.requestTitleObject.map((v) => v.toJson()).toList();
    }
    if (this.approvedObject != null) {
      data['ApprovedObject'] =
          this.approvedObject.map((v) => v.toJson()).toList();
    }
    if (this.requestItemObject != null) {
      data['RequestItemObject'] =
          this.requestItemObject.map((v) => v.toJson()).toList();
    }
    data['StatusCode'] = this.statusCode;
    data['IsSuccess'] = this.isSuccess;
    data['CommonErrors'] = this.commonErrors;
    return data;
  }
}

class RequestTitleObject {
  String requestID;
  String requestNo;
  String requestType;
  String empName;
  String empPosition;
  String dateRequest;
  String fileName;
  String attachedFile;
  String statusText;

  RequestTitleObject(
      {this.requestID,
      this.requestNo,
      this.requestType,
      this.empName,
      this.empPosition,
      this.dateRequest,
      this.fileName,
      this.attachedFile,
      this.statusText});

  RequestTitleObject.fromJson(Map<String, dynamic> json) {
    requestID = json['requestID'];
    requestNo = json['requestNo'];
    requestType = json['requestType'];
    empName = json['empName'];
    empPosition = json['empPosition'];
    dateRequest = json['dateRequest'];
    fileName = json['fileName'];
    attachedFile = json['attachedFile'];
    statusText = json['statusText'];
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
    return data;
  }
}

class ApprovedObject {
  String approvedName;
  String comment;
  String approvedDate;

  ApprovedObject({this.approvedName, this.comment, this.approvedDate});

  ApprovedObject.fromJson(Map<String, dynamic> json) {
    approvedName = json['approvedName'];
    comment = json['comment'];
    approvedDate = json['approvedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approvedName'] = this.approvedName;
    data['comment'] = this.comment;
    data['approvedDate'] = this.approvedDate;
    return data;
  }
}

class RequestItemObject {
  String itemID;
  String itemType;
  String duration;
  String strDate;
  String endDate;
  String returnDate;
  String requestFor;
  String requestReason;
  String responseName;

  RequestItemObject(
      {this.itemID,
      this.itemType,
      this.duration,
      this.strDate,
      this.endDate,
      this.returnDate,
      this.requestFor,
      this.requestReason,
      this.responseName});

  RequestItemObject.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    itemType = json['itemType'];
    duration = json['duration'];
    strDate = json['strDate'];
    endDate = json['endDate'];
    returnDate = json['returnDate'];
    requestFor = json['RequestFor'];
    requestReason = json['requestReason'];
    responseName = json['responseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['itemType'] = this.itemType;
    data['duration'] = this.duration;
    data['strDate'] = this.strDate;
    data['endDate'] = this.endDate;
    data['returnDate'] = this.returnDate;
    data['RequestFor'] = this.requestFor;
    data['requestReason'] = this.requestReason;
    data['responseName'] = this.responseName;
    return data;
  }
}
