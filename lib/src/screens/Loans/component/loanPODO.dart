class LoanHeader {
  String modelErrors;
  List<ResultObject> resultObject;
  int statusCode;
  bool isSuccess;
  String commonErrors;

  LoanHeader(
      {this.modelErrors,
      this.resultObject,
      this.statusCode,
      this.isSuccess,
      this.commonErrors});

  LoanHeader.fromJson(Map<String, dynamic> json) {
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
  int loanID;
  double loanAmount;
  double loanMonthlyFee;
  double loanAmuntMonth;
  double loanInterest;
  double loanPayment;
  double loanTotalBalance;

  ResultObject(
      {this.loanID,
      this.loanAmount,
      this.loanMonthlyFee,
      this.loanAmuntMonth,
      this.loanInterest,
      this.loanPayment,
      this.loanTotalBalance});

  ResultObject.fromJson(Map<String, dynamic> json) {
    loanID = json['loanID'];
    loanAmount = json['loanAmount'];
    loanMonthlyFee = json['loanMonthlyFee'];
    loanAmuntMonth = json['loanAmuntMonth'];
    loanInterest = json['loanInterest'];
    loanPayment = json['loanPayment'];
    loanTotalBalance = json['loanTotalBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loanID'] = this.loanID;
    data['loanAmount'] = this.loanAmount;
    data['loanMonthlyFee'] = this.loanMonthlyFee;
    data['loanAmuntMonth'] = this.loanAmuntMonth;
    data['loanInterest'] = this.loanInterest;
    data['loanPayment'] = this.loanPayment;
    data['loanTotalBalance'] = this.loanTotalBalance;
    return data;
  }
}
