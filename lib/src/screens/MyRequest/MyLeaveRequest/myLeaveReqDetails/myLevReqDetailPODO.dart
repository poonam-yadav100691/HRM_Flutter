class GetLevReqDetails {
  String modelErrors;
  List<RequestTitleObject> requestTitleObject;
  List<ApprovedObject> approvedObject;
  List<RequestItemObject> requestItemObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  GetLevReqDetails(
      {this.modelErrors,
      this.requestTitleObject,
      this.approvedObject,
      this.requestItemObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  GetLevReqDetails.fromJson(Map<String, dynamic> json) {
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

class ApprovedObject {
  String approvedName;
  String comment;
  String approvedDate;

  ApprovedObject({this.approvedName, this.approvedDate, this.comment});

  ApprovedObject.fromJson(Map<String, dynamic> json) {
    approvedName = json['approvedName'];
    approvedDate = json['approvedDate'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approvedName'] = this.approvedName;
    data['approvedDate'] = this.approvedDate;
    data['comment'] = this.comment;
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
  String RequestFor;
  String requestReason;
  String managerName;
  String LeaveName;
  String responseName;

  RequestItemObject(
      {this.itemID,
      this.itemType,
      this.duration,
      this.strDate,
      this.endDate,
      this.LeaveName,
      this.RequestFor,
      this.returnDate,
      this.requestFor,
      this.managerName,
      this.requestReason,
      this.responseName});

  RequestItemObject.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    itemType = json['itemType'];
    duration = json['duration'];
    strDate = json['strDate'];
    LeaveName = json['LeaveName'];
    endDate = json['endDate'];
    RequestFor = json['RequestFor'];
    managerName = json['managerName'];
    returnDate = json['returnDate'];
    requestFor = json['requestFor'];
    requestReason = json['requestReason'];
    responseName = json['responseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['itemType'] = this.itemType;
    data['duration'] = this.duration;
    data['LeaveName'] = this.LeaveName;
    data['strDate'] = this.strDate;
    data['RequestFor'] = this.RequestFor;
    data['managerName'] = this.managerName;
    data['endDate'] = this.endDate;
    data['returnDate'] = this.returnDate;
    data['requestFor'] = this.requestFor;
    data['requestReason'] = this.requestReason;
    data['responseName'] = this.responseName;
    return data;
  }
}

class RequestTitleObject {
  String requestID;
  String requestNo;
  String requestType;
  String managerName;
  String submitDate;
  String statusText;
  String fileName;
  String attachedFile;
  String otdate;

  RequestTitleObject(
      {this.requestID,
      this.requestNo,
      this.requestType,
      this.managerName,
      this.submitDate,
      this.statusText,
      this.fileName,
      this.attachedFile,
      this.otdate});

  RequestTitleObject.fromJson(Map<String, dynamic> json) {
    requestID = json['RequestID'];
    requestNo = json['RequestNo'];
    requestType = json['RequestType'];
    managerName = json['managerName'];
    submitDate = json['SubmitDate'];
    statusText = json['statusText'];
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
    data['statusText'] = this.statusText;
    data['fileName'] = this.fileName;
    data['attachedFile'] = this.attachedFile;
    data['otdate'] = this.otdate;

    return data;
  }
}
