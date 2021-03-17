class PayslipList {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  PayslipList(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  PayslipList.fromJson(Map<String, dynamic> json) {
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
  String slipID;
  String slipNo;
  String slipDate;
  String slipMonthYr;

  ResultObject({this.slipID, this.slipNo, this.slipDate, this.slipMonthYr});

  ResultObject.fromJson(Map<String, dynamic> json) {
    slipID = json['slipID'];
    slipNo = json['slipNo'];
    slipDate = json['slipDate'];
    slipMonthYr = json['slipMonthYr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slipID'] = this.slipID;
    data['slipNo'] = this.slipNo;
    data['slipDate'] = this.slipDate;
    data['slipMonthYr'] = this.slipMonthYr;
    return data;
  }
}
