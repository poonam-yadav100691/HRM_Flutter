class GetBalance {
  Null modelErrors;
  List<ResultObject1> resultObject;
  int statusCode;
  bool isSuccess;
  Null commonErrors;

  GetBalance(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  GetBalance.fromJson(Map<String, dynamic> json) {
    modelErrors = json['ModelErrors'];
    if (json['ResultObject'] != null) {
      resultObject = new List<ResultObject1>();
      json['ResultObject'].forEach((v) {
        resultObject.add(new ResultObject1.fromJson(v));
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

 class ResultObject1 {
  String leaveName;
  String leaveTotal;
  String leaveUse;

  ResultObject1({this.leaveName, this.leaveTotal, this.leaveUse});

  ResultObject1.fromJson(Map<String, dynamic> json) {
    leaveName = json['LeaveName'];
    leaveTotal = json['leaveTotal'];
    leaveUse = json['leaveUse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LeaveName'] = this.leaveName;
    data['leaveTotal'] = this.leaveTotal;
    data['leaveUse'] = this.leaveUse;
    return data;
  }
}
