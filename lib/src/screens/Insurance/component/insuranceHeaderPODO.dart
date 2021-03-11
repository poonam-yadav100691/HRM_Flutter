class InsuHeaderData {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  InsuHeaderData(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  InsuHeaderData.fromJson(Map<String, dynamic> json) {
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
  double insuranceBalance;
  double insuranceLimit;
  double insuranceUsed;

  ResultObject(
      {this.insuranceBalance, this.insuranceLimit, this.insuranceUsed});

  ResultObject.fromJson(Map<String, dynamic> json) {
    insuranceBalance = json['insuranceBalance'];
    insuranceLimit = json['insuranceLimit'];
    insuranceUsed = json['insuranceUsed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['insuranceBalance'] = this.insuranceBalance;
    data['insuranceLimit'] = this.insuranceLimit;
    data['insuranceUsed'] = this.insuranceUsed;
    return data;
  }
}
